Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab3JJW0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:26:37 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35258 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab3JJW0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:26:34 -0400
From: Sean Paul <seanpaul@chromium.org>
To: kgene.kim@samsung.com, dri-devel@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        inki.dae@samsung.com
Cc: airlied@linux.ie
Subject: [PATCH v3 0/5] Add some missing bits for exynos5250-snow
Date: Thu, 10 Oct 2013 18:26:13 -0400
Message-Id: <1381443978-5654-1-git-send-email-seanpaul@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380839303-4834-1-git-send-email-seanpaul@chromium.org>
References: <1380839303-4834-1-git-send-email-seanpaul@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set adds some missing devicetree nodes to the exynos5250-snow file as well
as adds a drm_bridge driver for the ptn3460 DP-LVDS chip. This chip is used in
the exynos5250-snow board.

Sean


Sean Paul (5):
 ARM: dts: Add fimd display-timings for exynos5250-snow
 ARM: dts: Add dp-controller node to exynos5250-snow
 drm/bridge: Add PTN3460 bridge driver
 drm/exynos: Initialize ptn3460 if present
 ARM: dts: Add ptn3460 to exynos5250-snow

 Documentation/devicetree/bindings/drm/bridge/ptn3460.txt |  27 ++++++++++++++++
 arch/arm/boot/dts/exynos5250-snow.dts                    |  50 ++++++++++++++++
 drivers/gpu/drm/Kconfig                                  |   2 ++
 drivers/gpu/drm/Makefile                                 |   1 +
 drivers/gpu/drm/bridge/Kconfig                           |   4 +++
 drivers/gpu/drm/bridge/Makefile                          |   3 ++
 drivers/gpu/drm/bridge/ptn3460.c                         | 349 ++++++++++++++++
 drivers/gpu/drm/exynos/exynos_drm_core.c                 |  44 ++++++++++++++++
 include/drm/bridge/ptn3460.h                             |  37 ++++++++++++++++

