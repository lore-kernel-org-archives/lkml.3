Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaEZITf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:19:35 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29493 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaEZIS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:18:58 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-e0-5382f8e67e5a
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        YoungJun Cho <yj44.cho@samsung.com>, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 9/9] drm/exynos: ipp: remove description of non-existing field
Date: Mon, 26 May 2014 10:17:23 +0200
Message-id: <1401092243-25568-10-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
References: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t/xa7rPfjQFG/x7Zm5xa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZvF3p2TGR24PO53H2fy6Nuy
	itHj8ya5AOYoLpuU1JzMstQifbsErozbx3rZCzrYKtavfMHWwNjD2sXIySEhYCLxY+1Kdghb
	TOLCvfVsXYxcHEICSxklGvYeYodw+pgkjt44zQRSxSagKfF38002EFtEQFni78RVjCBFzAIz
	mCUun+sCGyUs4Cex/80ysBUsAqoSC950s4DYvAIuEreXPWaBWCcncfLYZLAaTqD4648rgRZw
	AG1zlvj9nX8CI+8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCEB9mUH4+JjVocYBTgY
	lXh4TwQ1BQuxJpYVV+YeYpTgYFYS4W3+ABTiTUmsrEotyo8vKs1JLT7EyMTBKdXAuFYscOm8
	h5LHLyy0ujOTf8Ga/2xOWVdLPQ7t9P1j+433SVvF5tlZR1I8CwWzVc7/UTT4VDfR4aTIaZOq
	GWLfrHNbs5l7joRffvjYVVqTc+2TXUan919WFfy/tFhVX2begV31f6bJsW5bInajef6T9T8O
	Tpe4a3J1gcDmPK38hlbbu1tVUxXT+5RYijMSDbWYi4oTAYu7lOoOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipp_id field is removed from exynos_drm_ippdrv struct.
The patch removes its description as well.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.h b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
index e06c41e..7aaeaae 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
@@ -142,7 +142,6 @@ struct exynos_drm_ipp_ops {
  * @parent_dev: parent device information.
  * @dev: platform device.
  * @drm_dev: drm device.
- * @ipp_id: id of ipp driver.
  * @dedicated: dedicated ipp device.
  * @ops: source, destination operations.
  * @event_workq: event work queue.
-- 
1.9.1

