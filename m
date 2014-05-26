Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaEZIS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:18:59 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29493 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaEZIS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:18:57 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ce-5382f8e46e16
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: YoungJun Cho <yj44.cho@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 8/9] drm/exynos: ipp: update comment for struct drm_ipp_buf_info
Date: Mon, 26 May 2014 10:17:22 +0200
Message-id: <1401092243-25568-9-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
References: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xa7pPfjQFG3zaJW5x5et7NotJ9yew
	WLy4d5HF4mzTG3aLy7vmsFnMOL+PyWLtkbvsFjMmv2Sz2LtzMqMDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWxcup21oL77BXb171lbGA8wtbFyMkhIWAi8X/CL0YIW0ziwr31
	QHEuDiGBpYwST54vZwFJCAn0MUnceiUNYrMJaEr83XwTrFlEQFni78RVjCANzAIfmSRavn9g
	B0kICwRILH14lhXEZhFQldjybjOYzSvgLDHxcD/UNjmJk8cmg8U5BVwkXn9cydTFyAG0zFni
	93f+CYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEBNWXHYyLj1kdYhTgYFTi4T0R
	1BQsxJpYVlyZe4hRgoNZSYS3+QNQiDclsbIqtSg/vqg0J7X4ECMTB6dUA6OsevUU5f1hKopv
	D//fGftfXqDLWqzzc+ShG68WrNk945IKo9A0SZdCSQURGeU51v+5pwWvY3a/K2M79/V/na9c
	/cba23wf5be6rtvx0KPI8nHmqaZ5tzb7qfA0mD0zTmCtMN63gPOZy7HP63/+Pyf9+4pcCU/d
	m3Nb90dk/PzD/iP26j77sMdKLMUZiYZazEXFiQAJg3xjCAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: YoungJun Cho <yj44.cho@samsung.com>

The attribute gem_objs in struct drm_exynos_ipp_buf_info was
changed to handles. So the comment needs to be updated also.

Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
Acked-by: Seong-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Tested-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.h b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
index 09cb5a2..e06c41e 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
@@ -83,7 +83,7 @@ struct drm_exynos_ipp_cmd_node {
 /*
  * A structure of buffer information.
  *
- * @gem_objs: Y, Cb, Cr each gem object.
+ * @handles: Y, Cb, Cr each gem object handle.
  * @base: Y, Cb, Cr each planar address.
  */
 struct drm_exynos_ipp_buf_info {
-- 
1.9.1

