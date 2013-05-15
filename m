Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab3EOMAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:00:41 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40663 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3EOMAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:00:39 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/6] ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
Date: Wed, 15 May 2013 17:27:18 +0530
Message-Id: <1368619042-28252-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

remove init_enable from ths7303 pdata as it is no longer exists.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-davinci/board-dm365-evm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 2a66743..4e02ae7 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -510,7 +510,6 @@ struct ths7303_platform_data ths7303_pdata = {
 	.ch_1 = 3,
 	.ch_2 = 3,
 	.ch_3 = 3,
-	.init_enable = 1,
 };
 
 static struct amp_config_info vpbe_amp = {
-- 
1.7.4.1

