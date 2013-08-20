Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab3HTQQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:16:05 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37796 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3HTQQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:16:03 -0400
Subject: [PATCH v3 trivial 2/7] Docs: Kconfig: Use consistent whitespace
                                               indentation
Date: Tue, 20 Aug 2013 16:05:15 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Message-ID: <2211bcf3e32c43579b2e49c2013d6c75-mfwitten@gmail.com>
In-Reply-To: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
References: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Fri, 8 Apr 2011 14:30:21 +0000

Indentation is one tab; help text is offset by a further 2 spaces.

Only whitespace has been changed, as evidenced by:

  git diff --ignore-space-change

which exits successfully (no difference).

Signed-off-by: Michael Witten <mfwitten@gmail.com>
---
 drivers/net/wireless/ipw2x00/Kconfig | 98 ++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 91c0cb3..001efb4 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -12,37 +12,37 @@ config IPW2100
 	select LIB80211
 	select LIBIPW
 	---help---
-          A driver for the Intel PRO/Wireless 2100 Network 
+	  A driver for the Intel PRO/Wireless 2100 Network
 	  Connection 802.11b wireless network adapter.
 
-          See <file:Documentation/networking/README.ipw2100> for information on
+	  See <file:Documentation/networking/README.ipw2100> for information on
-          the capabilities currently enabled in this driver and for tips
+	  the capabilities currently enabled in this driver and for tips
-          for debugging issues and problems.
+	  for debugging issues and problems.
 
 	  In order to use this driver, you will need a firmware image for it.
-          You can obtain the firmware from
+	  You can obtain the firmware from
-	  <http://ipw2100.sf.net/>.  Once you have the firmware image, you 
+	  <http://ipw2100.sf.net/>.  Once you have the firmware image, you
 	  will need to place it in /lib/firmware.
 
-          You will also very likely need the Wireless Tools in order to
+	  You will also very likely need the Wireless Tools in order to
-          configure your card:
+	  configure your card:
 
-          <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
+	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
 
-          It is recommended that you compile this driver as a module (M)
+	  It is recommended that you compile this driver as a module (M)
-          rather than built-in (Y). This driver requires firmware at device
+	  rather than built-in (Y). This driver requires firmware at device
-          initialization time, and when built-in this typically happens
+	  initialization time, and when built-in this typically happens
-          before the filesystem is accessible (hence firmware will be
+	  before the filesystem is accessible (hence firmware will be
-          unavailable and initialization will fail). If you do choose to build
+	  unavailable and initialization will fail). If you do choose to build
-          this driver into your kernel image, you can avoid this problem by
+	  this driver into your kernel image, you can avoid this problem by
-          including the firmware and a firmware loader in an initramfs.
+	  including the firmware and a firmware loader in an initramfs.
- 
+
 config IPW2100_MONITOR
-        bool "Enable promiscuous mode"
+	bool "Enable promiscuous mode"
-        depends on IPW2100
+	depends on IPW2100
-        ---help---
+	---help---
 	  Enables promiscuous/monitor mode support for the ipw2100 driver.
-	  With this feature compiled into the driver, you can switch to 
+	  With this feature compiled into the driver, you can switch to
 	  promiscuous mode via the Wireless Tool's Monitor mode.  While in this
 	  mode, no packets can be sent.
 
@@ -50,17 +50,17 @@ config IPW2100_DEBUG
 	bool "Enable full debugging output in IPW2100 module."
 	depends on IPW2100
 	---help---
-	  This option will enable debug tracing output for the IPW2100.  
+	  This option will enable debug tracing output for the IPW2100.
 
-	  This will result in the kernel module being ~60k larger.  You can 
+	  This will result in the kernel module being ~60k larger.  You can
-	  control which debug output is sent to the kernel log by setting the 
+	  control which debug output is sent to the kernel log by setting the
-	  value in 
+	  value in
 
 	  /sys/bus/pci/drivers/ipw2100/debug_level
 
 	  This entry will only exist if this option is enabled.
 
-	  If you are not trying to debug or develop the IPW2100 driver, you 
+	  If you are not trying to debug or develop the IPW2100 driver, you
 	  most likely want to say N here.
 
 config IPW2200
@@ -73,37 +73,37 @@ config IPW2200
 	select LIB80211
 	select LIBIPW
 	---help---
-          A driver for the Intel PRO/Wireless 2200BG and 2915ABG Network
+	  A driver for the Intel PRO/Wireless 2200BG and 2915ABG Network
-	  Connection adapters. 
+	  Connection adapters.
 
-          See <file:Documentation/networking/README.ipw2200> for 
+	  See <file:Documentation/networking/README.ipw2200> for
-	  information on the capabilities currently enabled in this 
+	  information on the capabilities currently enabled in this
 	  driver and for tips for debugging issues and problems.
 
 	  In order to use this driver, you will need a firmware image for it.
-          You can obtain the firmware from
+	  You can obtain the firmware from
-	  <http://ipw2200.sf.net/>.  See the above referenced README.ipw2200 
+	  <http://ipw2200.sf.net/>.  See the above referenced README.ipw2200
 	  for information on where to install the firmware images.
 
-          You will also very likely need the Wireless Tools in order to
+	  You will also very likely need the Wireless Tools in order to
-          configure your card:
+	  configure your card:
 
-          <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
+	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
 
-          It is recommended that you compile this driver as a module (M)
+	  It is recommended that you compile this driver as a module (M)
-          rather than built-in (Y). This driver requires firmware at device
+	  rather than built-in (Y). This driver requires firmware at device
-          initialization time, and when built-in this typically happens
+	  initialization time, and when built-in this typically happens
-          before the filesystem is accessible (hence firmware will be
+	  before the filesystem is accessible (hence firmware will be
-          unavailable and initialization will fail). If you do choose to build
+	  unavailable and initialization will fail). If you do choose to build
-          this driver into your kernel image, you can avoid this problem by
+	  this driver into your kernel image, you can avoid this problem by
-          including the firmware and a firmware loader in an initramfs.
+	  including the firmware and a firmware loader in an initramfs.
 
 config IPW2200_MONITOR
-        bool "Enable promiscuous mode"
+	bool "Enable promiscuous mode"
-        depends on IPW2200
+	depends on IPW2200
-        ---help---
+	---help---
 	  Enables promiscuous/monitor mode support for the ipw2200 driver.
-	  With this feature compiled into the driver, you can switch to 
+	  With this feature compiled into the driver, you can switch to
 	  promiscuous mode via the Wireless Tool's Monitor mode.  While in this
 	  mode, no packets can be sent.
 
@@ -116,28 +116,28 @@ config IPW2200_PROMISCUOUS
 	depends on IPW2200_MONITOR
 	select IPW2200_RADIOTAP
 	---help---
-          Enables the creation of a second interface prefixed 'rtap'. 
+	  Enables the creation of a second interface prefixed 'rtap'.
-          This second interface will provide every received in radiotap
+	  This second interface will provide every received in radiotap
 	  format.
 
-          This is useful for performing wireless network analysis while
+	  This is useful for performing wireless network analysis while
-          maintaining an active association.
+	  maintaining an active association.
 
-          Example usage:
+	  Example usage:
 
-            % modprobe ipw2200 rtap_iface=1
+	    % modprobe ipw2200 rtap_iface=1
-            % ifconfig rtap0 up
+	    % ifconfig rtap0 up
-            % tethereal -i rtap0
+	    % tethereal -i rtap0

-          If you do not specify 'rtap_iface=1' as a module parameter then 
+	  If you do not specify 'rtap_iface=1' as a module parameter then
-          the rtap interface will not be created and you will need to turn 
+	  the rtap interface will not be created and you will need to turn
-          it on via sysfs:
+	  it on via sysfs:
-	
+
-            % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface
+	    % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface
 
 config IPW2200_QOS
-        bool "Enable QoS support"
+	bool "Enable QoS support"
-        depends on IPW2200
+	depends on IPW2200
 
 config IPW2200_DEBUG
 	bool "Enable full debugging output in IPW2200 module."
