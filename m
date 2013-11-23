Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab3KWIys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 03:54:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61188 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3KWIyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 03:54:44 -0500
Date: Sat, 23 Nov 2013 09:54:39 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-mmc@vger.kernel.org
cc: Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: [PATCH] mmc: tmio: remove myself as a maintainer
Message-ID: <Pine.LNX.4.64.1311230953420.9194@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:HSdg1oREIWCI/yE9lGJNPhLoU1gfaInAe2Hzw0p+sPT
 6nJcHjiCEN2ugLcfn9tKEmTRPKUqsYBcFCSv0sfv4OCw+TQlAw
 yQB+sidTyyxKSpBQ2uSr4aR1FwNIgMmo4Gd7GpU9ExUd63CE8X
 8tl3eJpXc83v1iZ74eAYSZLjotn1sxoi2Cht+nghNeqB0Fq9mh
 OpQKYG7UX+l4LCSuwjLfeHOsY5HGYh68M9Q8ihSLg6EROJKYIo
 FfeEF+YqThY5acR48K4zVBxMjTprDMrGkzHYmY18fRZ5BbFhuH
 CqdfdNYwEIeYhYqKkFdPICMe9wMeZQZZiaeVMGLLwi80WYJKTB
 HB9tfDHtdFQ8+OrJ3KLVHoeCEkYx+J4LSwv+7ABmlEbddneI2r
 Qwxh6kaKaCX0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I'm currently unable to dedicate sufficient time to driver
maintainership, remove myself from the maintainers list.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b5f4e68..e37e8c0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8643,7 +8643,6 @@ F:	include/linux/toshiba.h
 F:	include/uapi/linux/toshiba.h
 
 TMIO MMC DRIVER
-M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 M:	Ian Molton <ian@mnementh.co.uk>
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
-- 
1.7.2.5

