Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3LBThL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:37:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab3LBTSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Yusuke Goda <yusuke.goda.sx@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Chris Ball <cjb@laptop.org>
Subject: [PATCH 3.12 174/212] sh: ecovec: fixup compile error on sdhi
Date: Mon,  2 Dec 2013 11:16:05 -0800
Message-Id: <20131202191307.654557625@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit 357002b9c09e5332c9fcd4fa3d3c0fa00ca6ae4f upstream.

afa2c9407f8908 ("sh: ecovec24: Use MMC/SDHI CD and RO GPIO") added
.tmio_flags = TMIO_MMC_USE_GPIO_CD on sh_mobile_sdhi_info, but it needs
<linux/mfd/tmio.h> header.  This patch adds it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sh/boards/mach-ecovec24/setup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sh/boards/mach-ecovec24/setup.c
+++ b/arch/sh/boards/mach-ecovec24/setup.c
@@ -15,6 +15,7 @@
 #include <linux/mmc/sh_mmcif.h>
 #include <linux/mmc/sh_mobile_sdhi.h>
 #include <linux/mtd/physmap.h>
+#include <linux/mfd/tmio.h>
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>


