Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaESKyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:54:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31640 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbaESKy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:54:28 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-62-5379e2e10dff
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...)
Subject: [PATCH 0/8] drm/exynos/ipp: image post processing improvements
Date: Mon, 19 May 2014 12:54:02 +0200
Message-id: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t/xy7oPH1UGGzRdkLG4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mr4elCy4Dd7xe2701gaGE+zdTFyckgImEhMuT6DGcIWk7hwbz1Y
	XEhgKaPElhlaXYxcQHYfk8Sxy6/BEmwCmhJ/N98Es0UEdCSu93QzgxQxCzxjkrhzdx17FyMH
	h7CAu8TypUYgNSwCqhLXGxawgoR5BZwl5m/yhNglJ3Hy2GTWCYzcCxgZVjGKppYmFxQnpeca
	6RUn5haX5qXrJefnbmKEBMjXHYxLj1kdYhTgYFTi4f2RXhksxJpYVlyZe4hRgoNZSYR32w2g
	EG9KYmVValF+fFFpTmrxIUYmDk6pBkaFff8O9Mp1nfMsU0lJeKxz9cKf+26van/m/AtnzRCK
	bGqO0M2Tu7PUndc+c/O3aSYrHyiFX9y1TyPScdOe3+V+i3k3szyadONMMneBTOK0DWxFJzfs
	OPlDd5G9pHLUbKcvlrwOlbzXeTiWRAcf2T7z0ZLlb5IXP5kVvOXo34fKSvLn9sVMu39FiaU4
	I9FQi7moOBEA0Y6oi+4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of independent patches contains various improvement and fixes
for exynos_drm ipp framework and drivers.
The patchset is based on drm-exynos/exynos-drm-next branch.

Regards
Andrzej


Andrzej Hajda (8):
  drm/exynos/ipp: fix get_property IOCTL
  drm/exynos/ipp: correct ipp_id field initialization
  drm/exynos/ipp: simplify property list allocation
  drm/exynos/fimc: simplify pre-scaler ratio calculation
  drm/exynos/fimc: simplify irq masking function
  drm/exynos/fimc: replace hw access macros with functions
  drm/exynos/fimc: replace mutex by spinlock
  drm/exynos/fimc: simplify and rename fimc_dst_get_buf_seq

 drivers/gpu/drm/exynos/exynos_drm_fimc.c    | 427 ++++++++++++----------------
 drivers/gpu/drm/exynos/exynos_drm_gsc.c     |  10 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c     |  16 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.h     |   3 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c |   8 +-
 5 files changed, 196 insertions(+), 268 deletions(-)

-- 
1.9.1

