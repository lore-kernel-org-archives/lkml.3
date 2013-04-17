Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965797Ab3DQJFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:05:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65515 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab3DQJE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:04:56 -0400
Date: Wed, 17 Apr 2013 11:04:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] trivial: fix some then vs. than typos
Message-ID: <Pine.LNX.4.64.1304171048390.12878@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:y1NEJm22CTNZNlxj7z5i0VtJE73a0GBq31WoUgHN26w
 s7kscZ3C1KEZy4C3ITRbsD1B/hIPPlch+XZc7o2qBoTD2tWrWI
 DTvDm6O6iNJP1r4RFn7qA9CuaJVUDgmaXiaJRL7hag/7022m5O
 xhdvzNoFZYzXOzbKOpHq1rGAwJlpsxLgddloAc8hzaxL2+bHKF
 9mEbbfOzq0AoVfoFVn8e3TwmhLJyhGs8Yo1zKdNaIEHQH3lLGE
 Iv5ifO3cMTGhohJT6Wfn7gBmPzWi1+g3oOcqKO9MDGhdWiVWyH
 UWu249fAaz9GJW6PM9Lkn+nNWpwV4bi7JlKUWfn7xdo67T8XGP
 K4gbmWvsNjqBDgMbMnQDNWFdIXK06zPmZi9BwtnWwGLDhZngJL
 WrhxgyMH3tifA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some of the obvious then vs. than typos.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

These are just some of the typos, that a simple grep for patterns like

"er,\? then\|more,\? then\|less,\? then"

catches. Of course, they have to be manually verified, they produce a few 
false positives, but the success rate isn't too bad :-) Interestingly, 
opposites like

"[^e].,\? than\|[^r],\? than"

find almost no real typos. The reader is invited to continue these fixes 
;-)

 .../ABI/testing/sysfs-class-uwb_rc-wusbhc          |    2 +-
 Documentation/DocBook/media/v4l/controls.xml       |    4 ++--
 Documentation/hwmon/lm75                           |    2 +-
 Documentation/hwmon/thmc50                         |    2 +-
 Documentation/hwmon/w83781d                        |    2 +-
 Documentation/usb/mass-storage.txt                 |    4 ++--
 Documentation/watchdog/watchdog-kernel-api.txt     |    2 +-
 arch/arc/include/asm/entry.h                       |    2 +-
 arch/arc/kernel/entry.S                            |    2 +-
 arch/arm/Kconfig                                   |    2 +-
 arch/blackfin/lib/udivsi3.S                        |    2 +-
 arch/powerpc/oprofile/op_model_cell.c              |    2 +-
 arch/x86/kvm/x86.c                                 |    2 +-
 13 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-uwb_rc-wusbhc b/Documentation/ABI/testing/sysfs-class-uwb_rc-wusbhc
index 25b1e75..7e405c5 100644
--- a/Documentation/ABI/testing/sysfs-class-uwb_rc-wusbhc
+++ b/Documentation/ABI/testing/sysfs-class-uwb_rc-wusbhc
@@ -32,7 +32,7 @@ Description:
                 The maximum PHY rate to use for all connected devices.
                 This is only of limited use for testing and
                 development as the hardware's automatic rate
-                adaptation is better then this simple control.
+                adaptation is better than this simple control.
 
                 Refer to [ECMA-368] section 10.3.1.1 for the value to
                 use.
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 8d7a779..b72c2b53 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2726,7 +2726,7 @@ Applicable to the H264 encoder.</entry>
 		<entry>enum&nbsp;v4l2_mpeg_mfc51_video_frame_skip_mode</entry>
 	      </row>
 	      <row><entry spanname="descr">
-Indicates in what conditions the encoder should skip frames. If encoding a frame would cause the encoded stream to be larger then
+Indicates in what conditions the encoder should skip frames. If encoding a frame would cause the encoded stream to be larger than
 a chosen data limit then the frame will be skipped.
 Possible values are:</entry>
 	      </row>
@@ -2756,7 +2756,7 @@ Possible values are:</entry>
 If this setting is enabled, then the rate control logic of the encoder will calculate the average bitrate
 for a GOP and keep it below or equal the set bitrate target. Otherwise the rate control logic calculates the
 overall average bitrate for the stream and keeps it below or equal to the set bitrate. In the first case
-the average bitrate for the whole stream will be smaller then the set bitrate. This is caused because the
+the average bitrate for the whole stream will be smaller than the set bitrate. This is caused because the
 average is calculated for smaller number of frames, on the other hand enabling this setting will ensure that
 the stream will meet tight bandwidth contraints. Applicable to encoders.
 </entry>
diff --git a/Documentation/hwmon/lm75 b/Documentation/hwmon/lm75
index 69af1c7..46245db 100644
--- a/Documentation/hwmon/lm75
+++ b/Documentation/hwmon/lm75
@@ -62,7 +62,7 @@ The LM75 implements one temperature sensor. Limits can be set through the
 Overtemperature Shutdown register and Hysteresis register. Each value can be
 set and read to half-degree accuracy.
 An alarm is issued (usually to a connected LM78) when the temperature
-gets higher then the Overtemperature Shutdown value; it stays on until
+gets higher than the Overtemperature Shutdown value; it stays on until
 the temperature falls below the Hysteresis value.
 All temperatures are in degrees Celsius, and are guaranteed within a
 range of -55 to +125 degrees.
diff --git a/Documentation/hwmon/thmc50 b/Documentation/hwmon/thmc50
index 8a7772a..ab8c900 100644
--- a/Documentation/hwmon/thmc50
+++ b/Documentation/hwmon/thmc50
@@ -36,7 +36,7 @@ many processors), and a controllable fan/analog_out DAC. For the temperature
 sensors, limits can be set through the appropriate Overtemperature Shutdown
 register and Hysteresis register. Each value can be set and read to half-degree
 accuracy.  An alarm is issued (usually to a connected LM78) when the
-temperature gets higher then the Overtemperature Shutdown value; it stays on
+temperature gets higher than the Overtemperature Shutdown value; it stays on
 until the temperature falls below the Hysteresis value. All temperatures are in
 degrees Celsius, and are guaranteed within a range of -55 to +125 degrees.
 
diff --git a/Documentation/hwmon/w83781d b/Documentation/hwmon/w83781d
index 129b0a3..df8c8fb 100644
--- a/Documentation/hwmon/w83781d
+++ b/Documentation/hwmon/w83781d
@@ -82,7 +82,7 @@ is above the Overtemperature Shutdown value. The driver sets the
 hysteresis value for temp1 to 127 at initialization.
 
 For the other temperature sensor(s), an alarm is triggered when the
-temperature gets higher then the Overtemperature Shutdown value; it stays
+temperature gets higher than the Overtemperature Shutdown value; it stays
 on until the temperature falls below the Hysteresis value. But on the
 W83781D, there is only one alarm that functions for both other sensors!
 Temperatures are guaranteed within a range of -55 to +125 degrees. The
diff --git a/Documentation/usb/mass-storage.txt b/Documentation/usb/mass-storage.txt
index 59063ad..093bbd3 100644
--- a/Documentation/usb/mass-storage.txt
+++ b/Documentation/usb/mass-storage.txt
@@ -121,7 +121,7 @@
     capped.
 
     If this parameter is provided, and the number of files specified
-    in “file” argument is greater then the value of “luns”, all excess
+    in “file” argument is greater than the value of “luns”, all excess
     files will be ignored.
 
     If this parameter is not present, the number of logical units will
@@ -174,7 +174,7 @@
     Reflects the state of nofua flag for given logical unit.  It can
     be read and written.
 
-  Other then those, as usual, the values of module parameters can be
+  Other than those, as usual, the values of module parameters can be
   read from /sys/module/g_mass_storage/parameters/* files.
 
 * Other gadgets using mass storage function
diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index a0438f3..f0335e3 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -182,7 +182,7 @@ bit-operations. The status bits that are defined are:
   If this bit is set then the watchdog timer will not be able to stop.
 * WDOG_UNREGISTERED: this bit gets set by the WatchDog Timer Driver Core
   after calling watchdog_unregister_device, and then checked before calling
-  any watchdog_ops, so that you can be sure that no operations (other then
+  any watchdog_ops, so that you can be sure that no operations (other than
   unref) will get called after unregister, even if userspace still holds a
   reference to /dev/watchdog
 
diff --git a/arch/arc/include/asm/entry.h b/arch/arc/include/asm/entry.h
index eb2ae53..3481cd3 100644
--- a/arch/arc/include/asm/entry.h
+++ b/arch/arc/include/asm/entry.h
@@ -16,7 +16,7 @@
  *   Normally CPU does this automatically, however when doing FAKE rtie,
  *   we also need to explicitly do this. The problem in macros
  *   FAKE_RET_FROM_EXCPN and FAKE_RET_FROM_EXCPN_LOCK_IRQ was that this bit
- *   was being "CLEARED" rather then "SET". Actually "SET" clears ZOL context
+ *   was being "CLEARED" rather than "SET". Actually "SET" clears ZOL context
  *
  * Vineetg: May 5th 2008
  *  -Modified CALLEE_REG save/restore macros to handle the fact that
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 91eeab8..9346f56 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -41,7 +41,7 @@
  *   Normally CPU does this automatically, however when doing FAKE rtie,
  *   we need to explicitly do this. The problem in macros
  *   FAKE_RET_FROM_EXCPN and FAKE_RET_FROM_EXCPN_LOCK_IRQ was that this bit
- *   was being "CLEARED" rather then "SET". Since it is Loop INHIBIT Bit,
+ *   was being "CLEARED" rather than "SET". Since it is Loop INHIBIT Bit,
  *   setting it and not clearing it clears ZOL context
  *
  * Vineetg: May 16th, 2008
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 13b7394..0a3fb7e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1648,7 +1648,7 @@ config LOCAL_TIMERS
 	default y
 	select HAVE_ARM_TWD if (!ARCH_MSM_SCORPIONMP && !EXYNOS4_MCT)
 	help
-	  Enable support for local timers on SMP platforms, rather then the
+	  Enable support for local timers on SMP platforms, rather than the
 	  legacy IPI broadcast method.  Local timers allows the system
 	  accounting to be spread across the timer interval, preventing a
 	  "thundering herd" at every timer tick.
diff --git a/arch/blackfin/lib/udivsi3.S b/arch/blackfin/lib/udivsi3.S
index 748a6a2..5119871 100644
--- a/arch/blackfin/lib/udivsi3.S
+++ b/arch/blackfin/lib/udivsi3.S
@@ -66,7 +66,7 @@ ENTRY(___udivsi3)
 .Ly_16bit:
   /* We know that the upper 17 bits of Y might have bits set,
   ** or that the sign bit of X might have a bit. If Y is a
-  ** 16-bit number, but not bigger, then we can use the builtins
+  ** 16-bit number, but not bigger, than we can use the builtins
   ** with a post-divide correction.
   ** R3 currently holds Y>>15, which means R3's LSB is the
   ** bit we're interested in.
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index b9589c1..2bc5b8b 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -1060,7 +1060,7 @@ static int calculate_lfsr(int n)
 {
 	/*
 	 * The ranges and steps are in powers of 2 so the calculations
-	 * can be done using shifts rather then divide.
+	 * can be done using shifts rather than divide.
 	 */
 	int index;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f19ac0a..98e7449 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1360,7 +1360,7 @@ static bool kvm_get_time_and_clockread(s64 *kernel_ns, cycle_t *cycle_now)
  *
  * That is, when timespec0 != timespec1, M < N. Unfortunately that is not
  * always the case (the difference between two distinct xtime instances
- * might be smaller then the difference between corresponding TSC reads,
+ * might be smaller than the difference between corresponding TSC reads,
  * when updating guest vcpus pvclock areas).
  *
  * To avoid that problem, do not allow visibility of distinct
-- 
1.7.2.5

