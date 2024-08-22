import consumer from "./consumer";

document.addEventListener("DOMContentLoaded", () => {
  const bellLink = document.getElementById("notification-bell-link");
  const dropdownMenu = document.getElementById("notification-dropdown");
  const notificationCount = document.getElementById("notification-count");

  // Handle dropdown toggle
  if (bellLink && dropdownMenu) {
    bellLink.addEventListener("click", (event) => {
      event.preventDefault();
      const isHidden = dropdownMenu.style.display === "none";
      dropdownMenu.style.display = isHidden ? "block" : "none";
      dropdownMenu.setAttribute("aria-hidden", !isHidden);
    });
  }

  // Create a subscription to the NotificationChannel
  consumer.subscriptions.create("NotificationChannel", {
    received(data) {
      console.log("Received data:", data);

      // Update the notification count
      if (notificationCount) {
        const currentCount = parseInt(notificationCount.textContent || 0);
        notificationCount.textContent = currentCount + 1;
      }

      // Add new notification item to dropdown
      if (dropdownMenu) {
        const newItem = document.createElement("div");
        newItem.classList.add("notification-item");
        newItem.setAttribute("data-id", data.id);
        newItem.innerHTML = `<a href="${data.link}" class="nav-link" style="font-weight: bold;">${data.message}</a>`;
        dropdownMenu.prepend(newItem);
      }
    },
  });

  // Event delegation for marking notifications as read
  if (dropdownMenu) {
    dropdownMenu.addEventListener("click", (event) => {
      if (event.target.classList.contains("nav-link")) {
        event.preventDefault(); // Prevent the default link action
        const notificationItem = event.target.closest(".notification-item");
        const notificationId = notificationItem.getAttribute("data-id");

        fetch(`/notifications/${notificationId}/mark_as_read`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document
              .querySelector('meta[name="csrf-token"]')
              .getAttribute("content"),
          },
        })
          .then((response) => response.json())
          .then((data) => {
            console.log("Response data:", data);
            if (data.success) {
              // Update the notification item to normal font weight
              event.target.style.fontWeight = "normal";

              // Optionally update the notification count with the count from the server
              if (notificationCount) {
                notificationCount.textContent = data.unread_count || 0;
              }

              // Redirect to the show page
              window.location.href = event.target.href;
            } else {
              console.log("Failed to mark notification as read");
            }
          })
          .catch((error) => {
            console.error("Error:", error);
          });
      }
    });
  }
});
