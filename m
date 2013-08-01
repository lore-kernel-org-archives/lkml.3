Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab3HAQM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:12:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60507 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab3HAQM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:12:58 -0400
Date: Thu, 1 Aug 2013 09:12:55 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 08/18] ARM: msm: Switch to sched_clock_register()
Message-ID: <20130801161255.GA17642@codeaurora.org>
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
 <1375309877-16617-9-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1375309877-16617-9-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 03:31:07PM -0700, Stephen Boyd wrote:
>The 32 bit sched_clock interface now supports 64 bits. Upgrade to
>the 64 bit function to allow us to remove the 32 bit registration
>interface.
>
>Cc: David Brown <davidb@codeaurora.org>
>Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>---
> arch/arm/mach-msm/timer.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
