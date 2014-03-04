Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaCDSsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:48:55 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56807 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaCDSsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:48:54 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH 0/2] pm8921 driver cleanup
Date: Tue,  4 Mar 2014 10:48:50 -0800
Message-Id: <1393958932-3585-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two small cleanup patches for the pm8921 core driver.

Stephen Boyd (2):
  mfd: pm8921: Drop irq_set_lockdep_class() code
  mfd: pm8921: Use IRQCHIP_SKIP_SET_WAKE

 drivers/mfd/pm8921-core.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

