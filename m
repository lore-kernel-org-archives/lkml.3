Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaB0CQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:16:53 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33504 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbaB0CQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:16:51 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] Add qcom_defconfig and update msm_defconfig
Date: Wed, 26 Feb 2014 18:16:31 -0800
Message-Id: <1393467394-10907-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have mach-qcom, introduce a qcom_defconfig to match and
update the msm_defconfig to compile a board in mach-msm.

Stephen Boyd (3):
  ARM: config: Add qcom_defconfig
  ARM: msm: Silence readb/writeb warnings due to missing IOMEM()
  ARM: config: Update msm_defconfig

 arch/arm/configs/msm_defconfig                     | 25 +++-------------------
 arch/arm/configs/{msm_defconfig => qcom_defconfig} |  4 +---
 arch/arm/mach-msm/board-trout-gpio.c               |  2 +-
 arch/arm/mach-msm/board-trout.c                    |  2 +-
 arch/arm/mach-msm/board-trout.h                    |  2 +-
 5 files changed, 7 insertions(+), 28 deletions(-)
 copy arch/arm/configs/{msm_defconfig => qcom_defconfig} (97%)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

