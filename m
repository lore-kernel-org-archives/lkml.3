Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaG1Neo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:34:44 -0400
Received: from m12-14.163.com ([220.181.12.14]:33923 "EHLO m12-14.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbaG1Nem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:34:42 -0400
X-Coremail-DSSMTP: 121.225.181.73
From: weiyj_lk@163.com
To: David Airlie <airlied@linux.ie>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next] drm: Remove duplicated include from drm_plane_helper.c
Date: Mon, 28 Jul 2014 21:34:24 +0800
Message-Id: <1406554464-30542-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DsCowEBZXGdhUdZTKoSaCw--.95S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrAFWrWFyrKFyfCryrWw1kAFb_yoWxXFc_Ca
	47urnrZryDCFyvvFn0vFnIkFySkF45uF4rXrn0gasxAF90qF1fGw1UXa4rXr1DJrn5GF9F
	q3ZFqr17XF97CjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYbyCPUUUUU==
X-Originating-IP: [121.225.181.73]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiowHW1lD+Vi9LQQAAs-
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/drm_plane_helper.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_plane_helper.c b/drivers/gpu/drm/drm_plane_helper.c
index 6d13314..64ce96c 100644
--- a/drivers/gpu/drm/drm_plane_helper.c
+++ b/drivers/gpu/drm/drm_plane_helper.c
@@ -27,7 +27,6 @@
 #include <drm/drmP.h>
 #include <drm/drm_plane_helper.h>
 #include <drm/drm_rect.h>
-#include <drm/drm_plane_helper.h>
 
 #define SUBPIXEL_MASK 0xffff
 

