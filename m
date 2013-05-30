Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab3E3VP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 17:15:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56479 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581Ab3E3VPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 17:15:48 -0400
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2013 17:15:48 EDT
Date: Thu, 30 May 2013 14:06:58 -0700
From: David Brown <davidb@codeaurora.org>
To: Chen Gang <gang.chen@asianux.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Changes pulled into MSM tree
Message-ID: <20130530210658.GA13171@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes have been pulled into the msm tree for my next
pull request.  I expect to send the pull request after these sit in
next for a few days.  The changes can be seen at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git for-next

Chen Gang (1):
      arch: arm: mach-msm: using strlcpy instead of strncpy

Maxime Ripard (1):
      ARM: msm: Remove init_irq declaration in machine description

Rohit Vaswani (3):
      ARM: msm: Remove gpiomux-v2 and re-organize MSM_GPIOMUX configs
      ARM: msm: Remove unused and unmapped MSM_TLMM_BASE for 8x60
      gpio: msm: Add device tree and irqdomain support for gpio-msm-v2

Stephen Boyd (1):
      ARM: dts: msm: Fix bad register addresses

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
