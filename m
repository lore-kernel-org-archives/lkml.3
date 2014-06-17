Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128AbaFQOdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:33:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56240 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915AbaFQOdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:33:03 -0400
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH v2 0/2] drm/msm: update and activate iommu support
Date: Tue, 17 Jun 2014 10:32:36 -0400
Message-Id: <1403015558-13210-1-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <[PATCH] drm/msm: update and activate iommu support>
References: <[PATCH] drm/msm: update and activate iommu support>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am resending these patches after splitting them into two:
1) to update the IOMMU support
2) to activate the IOMMU

Stephane Viau (2):
  drm/msm: update iommu support
  drm/msm: activate iommu support

 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c | 28 +++++++++++++++++++++++-----
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h |  1 +
 drivers/gpu/drm/msm/msm_gem.c           |  6 ++++++
 drivers/gpu/drm/msm/msm_iommu.c         | 21 +++++++++++++++++++--
 drivers/gpu/drm/msm/msm_mmu.h           |  1 +
 5 files changed, 50 insertions(+), 7 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

