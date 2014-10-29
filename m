Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbaJ2SOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:14:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34160 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaJ2SOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:14:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: [PATCH 0/2] Two msm_serial break fixes
Date: Wed, 29 Oct 2014 11:14:36 -0700
Message-Id: <1414606478-13709-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch fixes a spinlock recursion. I suppose we can ship it back
to stable but I doubt anyone has noticed or cares. The second one adds
break support to the DM path, and allows sysrq to work.

Stephen Boyd (2):
  tty: serial: msm: Fix sysrq spinlock recursion on non-DM
  tty: serial: msm: Support sysrq on uartDM devices

 drivers/tty/serial/msm_serial.c | 47 +++++++++++++++++++++++++++++++----------
 drivers/tty/serial/msm_serial.h |  2 ++
 2 files changed, 38 insertions(+), 11 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

