Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3JAXl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 19:41:29 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:49772 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3JAXlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 19:41:14 -0400
From: Sean Paul <seanpaul@chromium.org>
To: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        inki.dae@samsung.com
Cc: airlied@linux.ie
Subject: [PATCH 0/5] Add some missing bits for exynos5250-snow
Date: Tue,  1 Oct 2013 19:40:55 -0400
Message-Id: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
X-Mailer: git-send-email 1.8.4
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

Documentation/devicetree/bindings/drm/bridge/ptn3460.txt |  27 +++++++++++++++++++++++++
arch/arm/boot/dts/exynos5250-snow.dts                    |  48 ++++++++++++++++++++++++++++++++++++++++++++
drivers/gpu/drm/Kconfig                                  |   2 ++
drivers/gpu/drm/Makefile                                 |   1 +
drivers/gpu/drm/bridge/Kconfig                           |   4 ++++
drivers/gpu/drm/bridge/Makefile                          |   3 +++
drivers/gpu/drm/bridge/ptn3460.c                         | 349 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
drivers/gpu/drm/exynos/exynos_drm_core.c                 |  44 +++++++++++++++++++++++++++++++++++++++-
include/drm/bridge/ptn3460.h                             |  36 +++++++++++++++++++++++++++++++++
9 files changed, 513 insertions(+), 1 deletion(-)

