Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab3HGUkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:40:36 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60697 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913Ab3HGUkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:40:35 -0400
Message-ID: <201308072040.r77KeYpx016080@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 7 Aug 2013 10:45:01 -0400
Subject: [PATCH] tile: add some tile drivers to MAINTAINERS
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, alphabetize the existing entries for tile.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 MAINTAINERS | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bf61e04..8f49198 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8288,9 +8288,13 @@ M:	Chris Metcalf <cmetcalf@tilera.com>
 W:	http://www.tilera.com/scm/
 S:	Supported
 F:	arch/tile/
-F:	drivers/tty/hvc/hvc_tile.c
-F:	drivers/net/ethernet/tile/
+F:	drivers/char/tile-srom.c
 F:	drivers/edac/tile_edac.c
+F:	drivers/net/ethernet/tile/
+F:	drivers/rtc/rtc-tile.c
+F:	drivers/tty/hvc/hvc_tile.c
+F:	drivers/usb/host/*-tilegx.c
+F:	include/linux/usb/tilegx.h
 
 TLAN NETWORK DRIVER
 M:	Samuel Chessman <chessman@tux.org>
-- 
1.8.3.1

