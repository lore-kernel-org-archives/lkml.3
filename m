Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaBRFdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 00:33:45 -0500
Received: from mail-yk0-f176.google.com ([209.85.160.176]:44617 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaBRFdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 00:33:44 -0500
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Feb 2014 00:33:44 EST
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 2/2] misc: add missing minor nodes
Date: Tue, 18 Feb 2014 02:27:25 -0300
Message-Id: <1392701245-4645-3-git-send-email-lucas.demarchi@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392701245-4645-1-git-send-email-lucas.demarchi@intel.com>
References: <1392701245-4645-1-git-send-email-lucas.demarchi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucas De Marchi <lucas.demarchi@intel.com>

Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
---
 Documentation/devices.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 04356f5..0ea1cc2 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -329,6 +329,7 @@ Your cooperation is appreciated.
 		filesystem across multiple physical disks.
 
  10 char	Non-serial mice, misc features
+		  0 = /dev/fram
 		  0 = /dev/logibm	Logitech bus mouse
 		  1 = /dev/psaux	PS/2-style mouse port
 		  2 = /dev/inportbm	Microsoft Inport bus mouse
@@ -411,6 +412,7 @@ Your cooperation is appreciated.
 		194 = /dev/zkshim	Zero-Knowledge network shim control
 		195 = /dev/elographics/e2201	Elographics touchscreen E271-2201
 		196 = /dev/vfio/vfio	VFIO userspace driver interface
+		197 = /dev/pxa3xx-gcu	PXA3xx graphics controller unit driver
 		198 = /dev/sexec	Signed executable interface
 		199 = /dev/scanners/cuecat :CueCat barcode scanner
 		200 = /dev/net/tun	TAP/TUN network device
@@ -452,6 +454,7 @@ Your cooperation is appreciated.
 		236 = /dev/mapper/control	Device-Mapper control device
 		237 = /dev/loop-control Loopback control device
 		238 = /dev/vhost-net	Host kernel accelerator for virtio net
+		239 = /dev/uhid		User-space I/O driver support for HID subsystem
 
 		240-254			Reserved for local use
 		255			Reserved for MISC_DYNAMIC_MINOR
-- 
1.9.0

