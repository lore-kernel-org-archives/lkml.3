Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaG1Nft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:35:49 -0400
Received: from m12-15.163.com ([220.181.12.15]:38248 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbaG1Nfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:35:48 -0400
X-Coremail-DSSMTP: 121.225.181.73
From: weiyj_lk@163.com
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next] drm/i915: Remove duplicated include from intel_dsi_panel_vbt.c
Date: Mon, 28 Jul 2014 21:35:22 +0800
Message-Id: <1406554522-30630-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: D8CowECJYHKhUdZTOrX6CQ--.173S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7WryUGr15Jw1rCr47Ary7Wrg_yoW3Jrb_C3
	43Zr17uryUAFsavFy2kFnxZr1YkF1YvrWkZ3Wrt3y3tFnxt34UWwsrZr15Xw1UW3Z3ArWD
	X3WFqryrZrZ3GjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYbVy3UUUUU==
X-Originating-IP: [121.225.181.73]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/xtbBDQPW1lIwSp-ONwAAsA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/i915/intel_dsi_panel_vbt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_dsi_panel_vbt.c b/drivers/gpu/drm/i915/intel_dsi_panel_vbt.c
index 47c7584..1439516 100644
--- a/drivers/gpu/drm/i915/intel_dsi_panel_vbt.c
+++ b/drivers/gpu/drm/i915/intel_dsi_panel_vbt.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 #include <video/mipi_display.h>
 #include <asm/intel-mid.h>
-#include <video/mipi_display.h>
 #include "i915_drv.h"
 #include "intel_drv.h"
 #include "intel_dsi.h"

