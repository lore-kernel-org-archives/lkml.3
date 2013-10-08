Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab3JHXnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 19:43:51 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62463 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755492Ab3JHXnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 19:43:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Subject: [PATCH 1/2] MAINTAINERS / Documentation: Update Rafael's e-mail address
Date: Wed, 09 Oct 2013 01:53:09 +0200
Message-ID: <1494498.ZhmudYOZXW@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1551451.ka7cHHvmPr@vostro.rjw.lan>
References: <1551451.ka7cHHvmPr@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1497638.9GTaktWk3U"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1497638.9GTaktWk3U
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

From: Rafael J. Wysocki <rjw@rjwysocki.net>

The e-mail address rjw@sisk.pl that I have been using for quite some
time is going to expire at one point, so replace it with a new one,
rjw@rjwysocki.net, everywhere in MAINTAINERS and Documentation/ABI.

Signed-off-by: Rafael J. Wysocki <rjw@rjwysocki.net>
---
 Documentation/ABI/testing/sysfs-devices-power |   32 +++++++++++++-------------
 Documentation/ABI/testing/sysfs-power         |   22 ++++++++---------
 MAINTAINERS                                   |   12 ++++-----
 3 files changed, 33 insertions(+), 33 deletions(-)

Index: linux-pm/Documentation/ABI/testing/sysfs-devices-power
===================================================================
--- linux-pm.orig/Documentation/ABI/testing/sysfs-devices-power
+++ linux-pm/Documentation/ABI/testing/sysfs-devices-power
@@ -1,6 +1,6 @@
 What:		/sys/devices/.../power/
 Date:		January 2009
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../power directory contains attributes
 		allowing the user space to check and modify some power
@@ -8,7 +8,7 @@ Description:
 
 What:		/sys/devices/.../power/wakeup
 Date:		January 2009
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../power/wakeup attribute allows the user
 		space to check if the device is enabled to wake up the system
@@ -34,7 +34,7 @@ Description:
 
 What:		/sys/devices/.../power/control
 Date:		January 2009
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../power/control attribute allows the user
 		space to control the run-time power management of the device.
@@ -53,7 +53,7 @@ Description:
 
 What:		/sys/devices/.../power/async
 Date:		January 2009
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../async attribute allows the user space to
 		enable or diasble the device's suspend and resume callbacks to
@@ -79,7 +79,7 @@ Description:
 
 What:		/sys/devices/.../power/wakeup_count
 Date:		September 2010
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../wakeup_count attribute contains the number
 		of signaled wakeup events associated with the device.  This
@@ -88,7 +88,7 @@ Description:
 
 What:		/sys/devices/.../power/wakeup_active_count
 Date:		September 2010
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../wakeup_active_count attribute contains the
 		number of times the processing of wakeup events associated with
@@ -98,7 +98,7 @@ Description:
 
 What:		/sys/devices/.../power/wakeup_abort_count
 Date:		February 2012
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../wakeup_abort_count attribute contains the
 		number of times the processing of a wakeup event associated with
@@ -109,7 +109,7 @@ Description:
 
 What:		/sys/devices/.../power/wakeup_expire_count
 Date:		February 2012
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../wakeup_expire_count attribute contains the
 		number of times a wakeup event associated with the device has
@@ -119,7 +119,7 @@ Description:
 
 What:		/sys/devices/.../power/wakeup_active
 Date:		September 2010
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../wakeup_active attribute contains either 1,
 		or 0, depending on whether or not a wakeup event associated with
@@ -129,7 +129,7 @@ Description:
 
 What:		/sys/devices/.../power/wakeup_total_time_ms
 Date:		September 2010
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../wakeup_total_time_ms attribute contains
 		the total time of processing wakeup events associated with the
@@ -139,7 +139,7 @@ Description:
 
 What:		/sys/devices/.../power/wakeup_max_time_ms
 Date:		September 2010
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../wakeup_max_time_ms attribute contains
 		the maximum time of processing a single wakeup event associated
@@ -149,7 +149,7 @@ Description:
 
 What:		/sys/devices/.../power/wakeup_last_time_ms
 Date:		September 2010
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../wakeup_last_time_ms attribute contains
 		the value of the monotonic clock corresponding to the time of
@@ -160,7 +160,7 @@ Description:
 
 What:		/sys/devices/.../power/wakeup_prevent_sleep_time_ms
 Date:		February 2012
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../wakeup_prevent_sleep_time_ms attribute
 		contains the total time the device has been preventing
@@ -189,7 +189,7 @@ Description:
 
 What:		/sys/devices/.../power/pm_qos_latency_us
 Date:		March 2012
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../power/pm_qos_resume_latency_us attribute
 		contains the PM QoS resume latency limit for the given device,
@@ -207,7 +207,7 @@ Description:
 
 What:		/sys/devices/.../power/pm_qos_no_power_off
 Date:		September 2012
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../power/pm_qos_no_power_off attribute
 		is used for manipulating the PM QoS "no power off" flag.  If
@@ -222,7 +222,7 @@ Description:
 
 What:		/sys/devices/.../power/pm_qos_remote_wakeup
 Date:		September 2012
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/devices/.../power/pm_qos_remote_wakeup attribute
 		is used for manipulating the PM QoS "remote wakeup required"
Index: linux-pm/MAINTAINERS
===================================================================
--- linux-pm.orig/MAINTAINERS
+++ linux-pm/MAINTAINERS
@@ -237,7 +237,7 @@ F:	drivers/platform/x86/acer-wmi.c
 
 ACPI
 M:	Len Brown <lenb@kernel.org>
-M:	Rafael J. Wysocki <rjw@sisk.pl>
+M:	Rafael J. Wysocki <rjw@rjwysocki.net>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 Q:	http://patchwork.kernel.org/project/linux-acpi/list/
@@ -2294,7 +2294,7 @@ S:	Maintained
 F:	drivers/net/ethernet/ti/cpmac.c
 
 CPU FREQUENCY DRIVERS
-M:	Rafael J. Wysocki <rjw@sisk.pl>
+M:	Rafael J. Wysocki <rjw@rjwysocki.net>
 M:	Viresh Kumar <viresh.kumar@linaro.org>
 L:	cpufreq@vger.kernel.org
 L:	linux-pm@vger.kernel.org
@@ -2325,7 +2325,7 @@ S:      Maintained
 F:      drivers/cpuidle/cpuidle-big_little.c
 
 CPUIDLE DRIVERS
-M:	Rafael J. Wysocki <rjw@sisk.pl>
+M:	Rafael J. Wysocki <rjw@rjwysocki.net>
 M:	Daniel Lezcano <daniel.lezcano@linaro.org>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
@@ -3547,7 +3547,7 @@ F:	fs/freevxfs/
 
 FREEZER
 M:	Pavel Machek <pavel@ucw.cz>
-M:	"Rafael J. Wysocki" <rjw@sisk.pl>
+M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>
 L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	Documentation/power/freezing-of-tasks.txt
@@ -3883,7 +3883,7 @@ F:	drivers/video/hgafb.c
 
 HIBERNATION (aka Software Suspend, aka swsusp)
 M:	Pavel Machek <pavel@ucw.cz>
-M:	"Rafael J. Wysocki" <rjw@sisk.pl>
+M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>
 L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	arch/x86/power/
@@ -8082,7 +8082,7 @@ F:	drivers/sh/
 SUSPEND TO RAM
 M:	Len Brown <len.brown@intel.com>
 M:	Pavel Machek <pavel@ucw.cz>
-M:	"Rafael J. Wysocki" <rjw@sisk.pl>
+M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>
 L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	Documentation/power/
Index: linux-pm/Documentation/ABI/testing/sysfs-power
===================================================================
--- linux-pm.orig/Documentation/ABI/testing/sysfs-power
+++ linux-pm/Documentation/ABI/testing/sysfs-power
@@ -1,6 +1,6 @@
 What:		/sys/power/
 Date:		August 2006
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/power directory will contain files that will
 		provide a unified interface to the power management
@@ -8,7 +8,7 @@ Description:
 
 What:		/sys/power/state
 Date:		August 2006
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/power/state file controls the system power state.
 		Reading from this file returns what states are supported,
@@ -22,7 +22,7 @@ Description:
 
 What:		/sys/power/disk
 Date:		September 2006
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/power/disk file controls the operating mode of the
 		suspend-to-disk mechanism.  Reading from this file returns
@@ -67,7 +67,7 @@ Description:
 
 What:		/sys/power/image_size
 Date:		August 2006
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/power/image_size file controls the size of the image
 		created by the suspend-to-disk mechanism.  It can be written a
@@ -84,7 +84,7 @@ Description:
 
 What:		/sys/power/pm_trace
 Date:		August 2006
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/power/pm_trace file controls the code which saves the
 		last PM event point in the RTC across reboots, so that you can
@@ -133,7 +133,7 @@ Description:
 
 What:		/sys/power/pm_async
 Date:		January 2009
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/power/pm_async file controls the switch allowing the
 		user space to enable or disable asynchronous suspend and resume
@@ -146,7 +146,7 @@ Description:
 
 What:		/sys/power/wakeup_count
 Date:		July 2010
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/power/wakeup_count file allows user space to put the
 		system into a sleep state while taking into account the
@@ -161,7 +161,7 @@ Description:
 
 What:		/sys/power/reserved_size
 Date:		May 2011
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/power/reserved_size file allows user space to control
 		the amount of memory reserved for allocations made by device
@@ -175,7 +175,7 @@ Description:
 
 What:		/sys/power/autosleep
 Date:		April 2012
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/power/autosleep file can be written one of the strings
 		returned by reads from /sys/power/state.  If that happens, a
@@ -192,7 +192,7 @@ Description:
 
 What:		/sys/power/wake_lock
 Date:		February 2012
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/power/wake_lock file allows user space to create
 		wakeup source objects and activate them on demand (if one of
@@ -219,7 +219,7 @@ Description:
 
 What:		/sys/power/wake_unlock
 Date:		February 2012
-Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/power/wake_unlock file allows user space to deactivate
 		wakeup sources created with the help of /sys/power/wake_lock.

--nextPart1497638.9GTaktWk3U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAABCAAGBQJSVJrqAAoJEILEb/54YlRxFGAP/06R237XdTfAaIBSd1kDrxgM
H+IKHST8tBVQ0uh9YRhrkM5/Y/Yl20pC0nqFqhQzGQj1jQHeKF11HeCWWr6jHG/W
SSoMRAsxhbHPbwV3UtaiQAKkMBr8cqcs23b8w0REw1hvUmkxWJBw1FgTEnWzedZk
USEkROGEv71aPpuFTYBEm3cTfGo/SpeXR58NoF2YlfQjT4qtXHVhheDUd7g5OkJq
PP7QwGnggVzLCElb1D9NNA4xm5htYfNVNBkbJbo7NWNQpkoq3GScX98IH8DWwqeg
x87vZtn1mgCJoLk/NYevkBvjMZOIAlV7nEvi4QwAK6HLI+4/5p1DPG/utKWJWEpw
L+u3RdggJFfM0Rg1NCt09sAYu4WCpYR4cuijz0hDOleItfLvFopPIjXTHkWcWoQA
IYhEqzuBDtz5U+Bhb1SJqsu/+mmpFdDClyF7qKg+M4Ism2wa0oYZMLIrw6sPFqLN
RRMhQZA4/UFIexkQm+xldn+iMqCnHjB4FYr8x+gxOHuGBY7RiHhGtGX9CmWv+q4U
rob3RhtlCtzEPmvXtcUMmaBmBet7z8aDdplExPo6YSb7T7QbCpf73e+wm7m7PySz
FUsj0SYXPKOj4SaoTURjIrgP9b75ppzBwcrIFwIv+BENZJSmywN1ZiOzfjjYL1ZV
c0n5LRJhtdDAq92SXU8O
=cuMr
-----END PGP SIGNATURE-----

--nextPart1497638.9GTaktWk3U--

