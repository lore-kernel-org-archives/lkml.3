Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaIPLOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:14:17 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:36669 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbaIPLOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:14:16 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] mmc: msm_sdcc: Cleanups
Date: Tue, 16 Sep 2014 16:47:43 +0530
Message-Id: <1410866268-15185-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset does some cleanups in msm sdcc driver.

Pramod Gurav (5):
  mmc: msm_sdcc: Switch to using managed resources
  mmc: msm_sdcc: Add support for platform_driver remove function
  mmc: msm_sdcc: Replace pr_ with dev_
  mmc: msm_sdcc: Remove duplicate check around dmares
  mmc: msm_sdcc: Remove unwanted initializations in probe

 drivers/mmc/host/msm_sdcc.c |  118 ++++++++++++++++++++++---------------------
 1 file changed, 61 insertions(+), 57 deletions(-)

-- 
1.7.9.5

