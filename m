Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbaKRRuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:50:16 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36059 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbaKRRuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:50:04 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 0/3] Update SMP, add CFG and Overlay support
Date: Tue, 18 Nov 2014 12:49:46 -0500
Message-Id: <1416332989-685-1-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set updates the SMP config for MDP5, introduces a Config module for
easier platform config update and allows MDP5 driver to use multiple CRTCs as
well as multiple planes (overlay).

Stephane Viau (3):
  drm/msm/mdp5: make SMP module dynamically configurable
  drm/msm/mdp5: introduce mdp5_cfg module
  drm/msm: add multiple CRTC and overlay support

 drivers/gpu/drm/msm/Makefile                |   2 +
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c     | 215 ++++++++++++++++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h     |  89 ++++++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c    | 265 +++++++++++++++++------
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c     | 325 ++++++++++++++++++++++++++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h     | 121 +++++++++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c |  13 ++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c     | 251 ++++++++-------------
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h     |  97 ++-------
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c   | 175 +++++++--------
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c     | 247 +++++++++++++++++----
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.h     |  22 +-
 12 files changed, 1379 insertions(+), 443 deletions(-)
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h

-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

