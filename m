Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbbAGV1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:27:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57107 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbbAGV1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:27:48 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 0/3] drm/msm: Add power supplies config for apq8084
Date: Wed,  7 Jan 2015 16:27:24 -0500
Message-Id: <1420666047-3690-1-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch makes it easier to have a different number of regulators
depending on the target. It is followed by the addition of the apq8084's
regulator config. Finally, the last patch makes things easier when a new
device needs to be added, especially when they share the same information.

Stephane Viau (3):
  drm/msm/hdmi: use dynamic allocation for hdmi resources
  drm/msm/hdmi: Add HDMI platform config for apq8084
  drm/msm/hdmi: rework hdmi configurations, using dt_match[]

 Documentation/devicetree/bindings/drm/msm/hdmi.txt |   2 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    | 144 ++++++++++++++-------
 drivers/gpu/drm/msm/hdmi/hdmi.h                    |   8 +-
 3 files changed, 105 insertions(+), 49 deletions(-)

-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

