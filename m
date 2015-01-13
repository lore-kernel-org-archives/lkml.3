Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbbAMWSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:18:32 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44234 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbbAMWSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:18:31 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, gbeeresh@codeaurora.org,
        Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 0/2] drm/msm/mdp5: hardware cursor support
Date: Tue, 13 Jan 2015 17:18:02 -0500
Message-Id: <1421187484-13875-1-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contains the hardware cursor changes. Split into two, as usual,
in order to separate header file generation from the rest of the code.

Beeresh Gopal (1):
  drm/msm/mdp5: Add hardware cursor support

Stephane Viau (1):
  drm/msm/mdp5: add register description for HW Cursor support

 drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h  |  79 +++++++++++++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c | 164 +++++++++++++++++++++++++++++++
 2 files changed, 243 insertions(+)

-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

