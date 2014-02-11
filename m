Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaBKGqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:46:44 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57282 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaBKGqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:46:42 -0500
Date: Mon, 10 Feb 2014 22:46:40 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Add devm_request_any_context_irq()
Message-ID: <20140211064640.GG10784@codeaurora.org>
References: <1388709460-19222-3-git-send-email-sboyd@codeaurora.org>
 <tip-0668d3065128d39449c097e62dbdb5707820137d@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-0668d3065128d39449c097e62dbdb5707820137d@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09, tip-bot for Stephen Boyd wrote:
> Commit-ID:  0668d3065128d39449c097e62dbdb5707820137d
> Gitweb:     http://git.kernel.org/tip/0668d3065128d39449c097e62dbdb5707820137d
> Author:     Stephen Boyd <sboyd@codeaurora.org>
> AuthorDate: Thu, 2 Jan 2014 16:37:32 -0800
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Sun, 9 Feb 2014 15:27:21 +0100
> 
> genirq: Add devm_request_any_context_irq()
> 
> Some drivers use request_any_context_irq() but there isn't a
> devm_* function for it. Add one so that these drivers don't need
> to explicitly free the irq on driver detach.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Link: http://lkml.kernel.org/r/1388709460-19222-3-git-send-email-sboyd@codeaurora.org
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Thanks Thomas. Is this going in for 3.14? Or can Dmitry pull a
branch from the tip tree into the input tree so that the
dependent input driver patches can be applied?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
