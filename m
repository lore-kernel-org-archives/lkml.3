Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaC1Nom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:44:42 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:47159 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaC1Nok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:44:40 -0400
Message-ID: <53357CC3.9070907@gmail.com>
Date: Fri, 28 Mar 2014 13:44:35 +0000
From: paulmcquad <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Paul McQuade <paulmcquad@gmail.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Shaohua Li <shaohua.li@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Subject: [PATCH 2/3] acpi:Remove whitespaces from tabs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c3bf9d7fff03065083f63ce8a5fa5822a61416f5 Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Thu, 27 Mar 2014 23:51:32 +0000
Subject: [PATCH 2/3] acpi:Remove whitespaces from tabs

Fix pointers is some files and remove whitespaces to make checkpatch clean.

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/acpi/acpi_memhotplug.c |  4 ++--
 drivers/acpi/acpi_processor.c  |  8 ++++----
 drivers/acpi/battery.c         |  4 ++--
 drivers/acpi/bus.c             |  6 +++---
 drivers/acpi/button.c          |  4 ++--
 drivers/acpi/custom_method.c   |  2 +-
 drivers/acpi/dock.c            |  2 +-
 drivers/acpi/ec.c              | 18 +++++++++---------
 drivers/acpi/fan.c             |  4 ++--
 drivers/acpi/internal.h        |  9 ++++-----
 drivers/acpi/numa.c            | 10 +++++-----
 11 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index b67be85..f5d458f 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -40,7 +40,7 @@
 #define _COMPONENT        ACPI_MEMORY_DEVICE_COMPONENT
 
 #undef PREFIX
-#define     PREFIX        "ACPI:memory_hp:"
+#define PREFIX        "ACPI:memory_hp:"
 
 ACPI_MODULE_NAME("acpi_memhotplug");
 
@@ -77,7 +77,7 @@ struct acpi_memory_info {
 };
 
 struct acpi_memory_device {
-    struct acpi_device * device;
+    struct acpi_device *device;
     unsigned int state;    /* State of the memory device */
     struct list_head res_list;
 };
diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index c29c2c3..b5f56e3 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -21,7 +21,7 @@
 
 #include <acpi/processor.h>
 
-#include <asm/cpu.h>
+#include <linux/cpu.h>
 
 #include "internal.h"
 
@@ -33,7 +33,7 @@ DEFINE_PER_CPU(struct acpi_processor *, processors);
 EXPORT_PER_CPU_SYMBOL(processors);
 
 /* --------------------------------------------------------------------------
-                                Errata Handling
+                Errata Handling
    -------------------------------------------------------------------------- */
 
 struct acpi_processor_errata errata __read_mostly;
@@ -160,7 +160,7 @@ static int acpi_processor_errata(void)
 }
 
 /* --------------------------------------------------------------------------
-                                Initialization
+                Initialization
    -------------------------------------------------------------------------- */
 
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
@@ -424,7 +424,7 @@ static int acpi_processor_add(struct acpi_device *device,
 
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 /* --------------------------------------------------------------------------
-                                    Removal
+                    Removal
    -------------------------------------------------------------------------- */
 
 static void acpi_processor_remove(struct acpi_device *device)
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 797a693..060672b 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -302,7 +302,7 @@ static enum power_supply_property energy_battery_props[] = {
 };
 
 /* --------------------------------------------------------------------------
-                               Battery Management
+                Battery Management
    -------------------------------------------------------------------------- */
 struct acpi_offsets {
     size_t offset;        /* offset inside struct acpi_sbs_battery */
@@ -719,7 +719,7 @@ static void acpi_battery_refresh(struct acpi_battery *battery)
 }
 
 /* --------------------------------------------------------------------------
-                                 Driver Interface
+                Driver Interface
    -------------------------------------------------------------------------- */
 
 static void acpi_battery_notify(struct acpi_device *device, u32 event)
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index fcb59c2..4426869 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -82,7 +82,7 @@ static struct dmi_system_id dsdt_dmi_table[] __initdata = {
 #endif
 
 /* --------------------------------------------------------------------------
-                                Device Management
+                Device Management
    -------------------------------------------------------------------------- */
 
 acpi_status acpi_bus_get_status_handle(acpi_handle handle,
@@ -330,7 +330,7 @@ static void acpi_bus_osc_support(void)
 }
 
 /* --------------------------------------------------------------------------
-                             Notification Handling
+                Notification Handling
    -------------------------------------------------------------------------- */
 
 /**
@@ -397,7 +397,7 @@ static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
 }
 
 /* --------------------------------------------------------------------------
-                             Initialization/Cleanup
+                Initialization/Cleanup
    -------------------------------------------------------------------------- */
 
 static int __init acpi_bus_init_irq(void)
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 714e957..397707f 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -108,7 +108,7 @@ static BLOCKING_NOTIFIER_HEAD(acpi_lid_notifier);
 static struct acpi_device *lid_device;
 
 /* --------------------------------------------------------------------------
-                              FS Interface (/proc)
+                FS Interface (/proc)
    -------------------------------------------------------------------------- */
 
 static struct proc_dir_entry *acpi_button_dir;
@@ -216,7 +216,7 @@ static int acpi_button_remove_fs(struct acpi_device *device)
 }
 
 /* --------------------------------------------------------------------------
-                                Driver Interface
+                Driver Interface
    -------------------------------------------------------------------------- */
 int acpi_lid_notifier_register(struct notifier_block *nb)
 {
diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
index c68e724..d0ae76c 100644
--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -19,7 +19,7 @@ static struct dentry *cm_dentry;
 
 /* /sys/kernel/debug/acpi/custom_method */
 
-static ssize_t cm_write(struct file *file, const char __user * user_buf,
+static ssize_t cm_write(struct file *file, const char __user *user_buf,
             size_t count, loff_t *ppos)
 {
     static char *buf;
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 5bfd769..2c6db21 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -749,7 +749,7 @@ static ssize_t write_undock(struct device *dev, struct device_attribute *attr,
     begin_undock(dock_station);
     ret = handle_eject_request(dock_station, ACPI_NOTIFY_EJECT_REQUEST);
     acpi_scan_lock_release();
-    return ret ? ret: count;
+    return ret ? ret : count;
 }
 static DEVICE_ATTR(undock, S_IWUSR, NULL, write_undock);
 
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index d7d32c2..df08b95 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -41,7 +41,7 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/dmi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include "internal.h"
 
@@ -121,7 +121,7 @@ static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
 static int EC_FLAGS_CLEAR_ON_RESUME; /* Needs acpi_ec_clear() on boot/resume */
 
 /* --------------------------------------------------------------------------
-                             Transaction Management
+                Transaction Management
    -------------------------------------------------------------------------- */
 
 static inline u8 acpi_ec_read_status(struct acpi_ec *ec)
@@ -362,7 +362,7 @@ static int acpi_ec_burst_disable(struct acpi_ec *ec)
                 acpi_ec_transaction(ec, &t) : 0;
 }
 
-static int acpi_ec_read(struct acpi_ec *ec, u8 address, u8 * data)
+static int acpi_ec_read(struct acpi_ec *ec, u8 address, u8 *data)
 {
     int result;
     u8 d;
@@ -419,8 +419,8 @@ int ec_write(u8 addr, u8 val)
 EXPORT_SYMBOL(ec_write);
 
 int ec_transaction(u8 command,
-           const u8 * wdata, unsigned wdata_len,
-           u8 * rdata, unsigned rdata_len)
+           const u8 *wdata, unsigned wdata_len,
+           u8 *rdata, unsigned rdata_len)
 {
     struct transaction t = {.command = command,
                 .wdata = wdata, .rdata = rdata,
@@ -506,7 +506,7 @@ void acpi_ec_unblock_transactions_early(void)
         clear_bit(EC_FLAGS_BLOCKED, &first_ec->flags);
 }
 
-static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 * data)
+static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 *data)
 {
     int result;
     u8 d;
@@ -530,7 +530,7 @@ static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 * data)
 }
 
 /* --------------------------------------------------------------------------
-                                Event Management
+                Event Management
    -------------------------------------------------------------------------- */
 int acpi_ec_add_query_handler(struct acpi_ec *ec, u8 query_bit,
                   acpi_handle handle, acpi_ec_query_func func,
@@ -646,7 +646,7 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 }
 
 /* --------------------------------------------------------------------------
-                             Address Space Management
+                Address Space Management
    -------------------------------------------------------------------------- */
 
 static acpi_status
@@ -691,7 +691,7 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
 }
 
 /* --------------------------------------------------------------------------
-                               Driver Interface
+                Driver Interface
    -------------------------------------------------------------------------- */
 static acpi_status
 ec_parse_io_ports(struct acpi_resource *resource, void *context);
diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 09e423f..3977a0e 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -27,7 +27,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/thermal.h>
 #include <linux/acpi.h>
 
@@ -122,7 +122,7 @@ static const struct thermal_cooling_device_ops fan_cooling_ops = {
 };
 
 /* --------------------------------------------------------------------------
-                                 Driver Interface
+                Driver Interface
    -------------------------------------------------------------------------- */
 
 static int acpi_fan_add(struct acpi_device *device)
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index dedbb2d..c4d7767 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -76,7 +76,7 @@ bool acpi_queue_hotplug_work(struct work_struct *work);
 bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent);
 
 /* --------------------------------------------------------------------------
-                     Device Node Initialization / Removal
+            Device Node Initialization / Removal
    -------------------------------------------------------------------------- */
 #define ACPI_STA_DEFAULT (ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED | \
               ACPI_STA_DEVICE_UI | ACPI_STA_DEVICE_FUNCTIONING)
@@ -113,7 +112,7 @@ int acpi_wakeup_device_init(void);
 void acpi_early_processor_set_pdc(void);
 
 /* --------------------------------------------------------------------------
-                                  Embedded Controller
+                Embedded Controller
    -------------------------------------------------------------------------- */
 struct acpi_ec {
     acpi_handle handle;
@@ -148,7 +147,7 @@ void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit);
 
 
 /*--------------------------------------------------------------------------
-                                  Suspend/Resume
+                Suspend/Resume
   -------------------------------------------------------------------------- */
 extern int acpi_sleep_init(void);
 
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 9e6816e..b2a064c 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -103,7 +103,7 @@ acpi_table_print_srat_entry(struct acpi_subtable_header *header)
                       "SRAT Processor (id[0x%02x] eid[0x%02x]) in proximity domain %d %s\n",
                       p->apic_id, p->local_sapic_eid,
                       p->proximity_domain_lo,
-                      (p->flags & ACPI_SRAT_CPU_ENABLED)?
+                      (p->flags & ACPI_SRAT_CPU_ENABLED) ?
                       "enabled" : "disabled"));
         }
 #endif                /* ACPI_DEBUG_OUTPUT */
@@ -119,11 +119,11 @@ acpi_table_print_srat_entry(struct acpi_subtable_header *header)
                       (unsigned long)p->base_address,
                       (unsigned long)p->length,
                       p->proximity_domain,
-                      (p->flags & ACPI_SRAT_MEM_ENABLED)?
+                      (p->flags & ACPI_SRAT_MEM_ENABLED) ?
                       "enabled" : "disabled",
@@ -241,7 +241,7 @@ acpi_parse_processor_affinity(struct acpi_subtable_header *header,
 static int __initdata parsed_numa_memblks;
 
 static int __init
-acpi_parse_memory_affinity(struct acpi_subtable_header * header,
+acpi_parse_memory_affinity(struct acpi_subtable_header *header,
                const unsigned long end)
 {
     struct acpi_srat_mem_affinity *memory_affinity;
-- 
1.8.3.2

