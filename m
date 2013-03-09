Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab3CIQ4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 11:56:37 -0500
Received: from mailserv.regfish.com ([79.140.61.33]:33377 "EHLO
	mailserv.regfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735Ab3CIQ4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 11:56:36 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Mar 2013 11:56:36 EST
MIME-Version: 1.0
Date: Sat, 09 Mar 2013 17:41:29 +0100
From: Benjamin Pabst <os@xeviox.com>
To: <linux-kernel@vger.kernel.org>
Subject: PROBLEM: rtl8192cu driver issue
Reply-To: os@xeviox.com
Message-ID: <582d04385829105911e6152cf33268e9@mailserv.regfish.com>
User-Agent: regfish Webmail/1.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] rtl8192cu driver issue with Kernel version 3.7.5 and 3.7.10
(archlinux)
[2.] Since last update (Kernel 3.7.5) the rtl8192cu driver does not work
properly (only tested with Kernel 3.7.5 and 3.7.10).
     Although the hardware is correctly recognized and modules are load
(rtlwifi, rtl8192cu, rtl8192c_common), the corresponding
     device is either not created (checked with "ip link") or the device
is not able to scan or connect to any networks.
     An additional problem is a broken shutdown when the modules are load
(shutdown process stops at something like "All DMs unload",
     sorry, cannot remember the exact words).
[3.] networking, wireless, drivers, rtl8192cu
[4.] Linux version 3.7.10-1-ARCH (tobias@T-POWA-LX) (gcc version 4.7.2
(GCC) ) #1 SMP PREEMPT Thu Feb 28 09:50:17 CET 2013
[5.] 
[6.] Plugging the a usb device with rtl8192cu chipset should trigger the
problem
[7.1.] Archlinux x64, connection and scanning tested with "Wicd"
[7.2.] model name	: AMD Phenom(tm) II X4 965 Processor
[8.] I have checked Openelec sources, where the usb device works fine.
They have applied a patch to replace "thread" with "kthread" to
     the driver. I also installed the following package
"https://aur.archlinux.org/packages/dkms-8192cu/" from Archlinux AUR which
     seems to do the same (applying the "kthread" patch). Using the
patched driver everything seems to work fine (further testing
     may be necessary).

Hope that might help (its my first report).

Greetings from Germany
Ben
