Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbaCDTQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:16:54 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:58256 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbaCDTQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:16:52 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH] staging: usbip: userspace: increase version to 2.0
Date: Tue,  4 Mar 2014 21:16:39 +0200
Message-Id: <1393960599-21379-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/userspace/configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index 25bf160..607d05c 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.59)
-AC_INIT([usbip-utils], [1.1.1], [linux-usb@vger.kernel.org])
+AC_INIT([usbip-utils], [2.0], [linux-usb@vger.kernel.org])
 AC_DEFINE([USBIP_VERSION], [0x00000111], [binary-coded decimal version number])
 
 CURRENT=0
-- 
1.8.1.2

