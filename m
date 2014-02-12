Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaBLKIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:08:55 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:65521 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbaBLKIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:08:51 -0500
Message-ID: <1392199729.23759.20.camel@x220>
Subject: [PATCH] [media] s5p-fimc: Remove reference to outdated macro
From: Paul Bolle <pebolle@tiscali.nl>
To: Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Richard Weinberger <richard@nod.at>, linux-media@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Feb 2014 11:08:49 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2014 10:08:50.0327 (UTC) FILETIME=[6D11CA70:01CF27DA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol S5P_SETUP_MIPIPHY was removed in v3.13. Remove a
reference to its macro from a list of Kconfig options.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
See commit e66f233dc7f7 ("ARM: Samsung: Remove the MIPI PHY setup
code"). Should one or more options be added to replace
S5P_SETUP_MIPIPHY? I couldn't say. It's safe to remove this one anyway.

 Documentation/video4linux/fimc.txt | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/video4linux/fimc.txt b/Documentation/video4linux/fimc.txt
index e51f1b5..7d6e160 100644
--- a/Documentation/video4linux/fimc.txt
+++ b/Documentation/video4linux/fimc.txt
@@ -151,9 +151,8 @@ CONFIG_S5P_DEV_FIMC1  \
 CONFIG_S5P_DEV_FIMC2  |    optional
 CONFIG_S5P_DEV_FIMC3  |
 CONFIG_S5P_SETUP_FIMC /
-CONFIG_S5P_SETUP_MIPIPHY \
-CONFIG_S5P_DEV_CSIS0     | optional for MIPI-CSI interface
-CONFIG_S5P_DEV_CSIS1     /
+CONFIG_S5P_DEV_CSIS0  \    optional for MIPI-CSI interface
+CONFIG_S5P_DEV_CSIS1  /
 
 Except that, relevant s5p_device_fimc? should be registered in the machine code
 in addition to a "s5p-fimc-md" platform device to which the media device driver
-- 
1.8.5.3

