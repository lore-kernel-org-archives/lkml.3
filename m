Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3KWIz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 03:55:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63287 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3KWIz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 03:55:26 -0500
Date: Sat, 23 Nov 2013 09:55:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-mmc@vger.kernel.org
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH] V4L2: remove myself as a maintainer of two drivers
Message-ID: <Pine.LNX.4.64.1311230954410.9194@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:/rbRvwWCc6jvMIHYFwuYN+qmNFjsxSKx5rDQvoxi6DG
 cIUvK3zYDNYdh+spq4cT8ESvg4NHBtgzof4pua6uAwkBl40qRx
 zeUCA4tqdEMNxbB/ZhNjwFQA4BaVKEh3tyjFGwGcsxe0B+nfR+
 56C65EZBfgS6vPd+k8YwHxP/za9dsACfd7AkclcjtxPlF+j601
 dqkz/GlXyhuQM+kOawsO/VWzUO2OvM3v5VcN9u1oLyeY6IAWMm
 hi1xJjxpE4O1PlY8j0V/rz6Z1y4KZGgCb+uLwpmx9PdH8ODI9y
 zIrIeXqWyA+p2XVTFsbRO+pPRrxTsvP+rZfEIXAniPwa8O1JX4
 /J/9y5fA1FCW04lIQ2tyklAXtnjpvTR+vbCyxSr9WbMW3Ingnd
 ShTEHHlirpZZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I'm currently unable to dedicate sufficient time to the maintainership
of these two drivers update their status to "orphan" until new maintainers
appear.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 MAINTAINERS |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e37e8c0..f7d6b05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7654,15 +7654,13 @@ F:	drivers/media/usb/siano/
 F:	drivers/media/mmc/siano/
 
 SH_VEU V4L2 MEM2MEM DRIVER
-M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/media/platform/sh_veu.c
 
 SH_VOU V4L2 OUTPUT DRIVER
-M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org
-S:	Odd Fixes
+S:	Orphan
 F:	drivers/media/platform/sh_vou.c
 F:	include/media/sh_vou.h
 
-- 
1.7.2.5

