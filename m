Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaGGOjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:39:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39946 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbaGGOjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:39:39 -0400
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH] drm/msm/mdp5: add support for MDP5 v1.3
Date: Mon,  7 Jul 2014 10:34:00 -0400
Message-Id: <1404743641-16847-1-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch uses a slightly modified version of envytools/headergen2 (thanks
Rob!) to add support for a newer version of MDP5: v1.3 (up to v1.2 is
supported as of now), through dynamic offsets.

Stephane Viau (1):
  drm/msm/mdp5: add support for MDP5 v1.3

 drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h | 442 +++++++++++++++++++-------------
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c | 151 +++++++++--
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h |  25 ++
 3 files changed, 426 insertions(+), 192 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

