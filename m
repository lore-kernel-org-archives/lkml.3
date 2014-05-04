Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaEDP0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:26:34 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49709 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaEDP0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:26:32 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanpaul@chromium.org, marcheu@chromium.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 0/4] drm/exynos/mixer: small cleanups
Date: Sun,  4 May 2014 23:26:17 +0800
Message-Id: <1399217181-26442-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't actually have a way of testing the video processor changes, but they
seem correct from looking at the code.  Hopefully someone has a way of testing
them.

Daniel Kurtz (4):
  drm/exynos/mixer: move format definitions to regs-mixer
  drm/exynos/mixer: use MXR_GRP_SXY_SY
  drm/exynos/mixer: planes are not disabled by setting dma_addr to zero
  drm/exynos/mixer: add support for NV21

 drivers/gpu/drm/exynos/exynos_drm_plane.c |  1 +
 drivers/gpu/drm/exynos/exynos_mixer.c     | 54 +++++++++++--------------------
 drivers/gpu/drm/exynos/regs-mixer.h       |  4 +++
 3 files changed, 23 insertions(+), 36 deletions(-)

-- 
1.9.1.423.g4596e3a

