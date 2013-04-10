Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936316Ab3DJVJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:09:12 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6070 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759774Ab3DJVIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:08:40 -0400
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="37345524"
From: Michael Bohan <mbohan@codeaurora.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 0/2] hrtimer preemption bug fixes
Date: Wed, 10 Apr 2013 14:07:46 -0700
Message-Id: <1365628068-32738-1-git-send-email-mbohan@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a couple of hrtimer bug fixes related to preemption.

Michael Bohan (2):
  hrtimer: Consider preemption when migrating hrtimer cpu_bases
  hrtimer: Prevent enqueue of hrtimer on dead CPU

 kernel/hrtimer.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

