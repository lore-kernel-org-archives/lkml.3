Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3EQLYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:24:14 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:61206 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3EQLYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:24:13 -0400
Date: Fri, 17 May 2013 19:24:05 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
X-X-Sender: zx@M2420
To: hans.verkuil@cisco.com, mchehab@redhat.com,
        ismael.luceno@corp.bluecherry.net
cc: linux-kernel@vger.kernel.org, gregkh@suse.de, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging/solo6x10: select the desired font
Message-ID: <alpine.DEB.2.02.1305171916540.10247@M2420>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiong Zhou <jencce.kernel@gmail.com>

Make sure FONT_8x16 can be found by find_font().

Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
---
 drivers/staging/media/solo6x10/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/solo6x10/Kconfig b/drivers/staging/media/solo6x10/Kconfig
index ec32776..0bc743b 100644
--- a/drivers/staging/media/solo6x10/Kconfig
+++ b/drivers/staging/media/solo6x10/Kconfig
@@ -4,6 +4,7 @@ config SOLO6X10
 	select VIDEOBUF2_DMA_SG
 	select VIDEOBUF2_DMA_CONTIG
 	select SND_PCM
+	select FONT_8x16
 	---help---
 	  This driver supports the Softlogic based MPEG-4 and h.264 codec
 	  cards.
