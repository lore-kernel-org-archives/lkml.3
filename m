Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaFFKmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:42:35 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61707 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaFFKmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:42:32 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, pebolle@tiscali.nl, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, horms@verge.net.au, geert@linux-m68k.org,
        laurent.pinchart@ideasonboard.com, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, dan.carpenter@oracle.com
Date: Fri, 06 Jun 2014 19:44:35 +0900
Message-Id: <20140606104435.4423.40909.sendpatchset@w520>
In-Reply-To: <20140606104408.4423.36098.sendpatchset@w520>
References: <20140606104408.4423.36098.sendpatchset@w520>
Subject: [PATCH v3 03/05] staging: emxx_udc: Add TODO file
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm+renesas@opensource.se>

Add a TODO file for emxx_udc to show what is left to do.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
---

 Changes since V2:
 - None

 Changes since V1:
 - New patch

 drivers/staging/emxx_udc/TODO |    4 ++++
 1 file changed, 4 insertions(+)

--- /dev/null
+++ work/drivers/staging/emxx_udc/TODO	2014-05-29 18:08:58.000000000 +0900
@@ -0,0 +1,4 @@
+* add clock framework support (platform device with CCF needs special care)
+* break out board-specific VBUS GPIO to work with multiplatform
+* DT bindings
+* move driver into drivers/usb/gadget/
