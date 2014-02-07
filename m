Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaBGVIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:08:20 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57831 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaBGVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:08:18 -0500
Date: Fri, 7 Feb 2014 13:08:17 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-msm@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 02/10] genirq: Add devm_request_any_context_irq()
Message-ID: <20140207210816.GD12815@codeaurora.org>
References: <1388709460-19222-1-git-send-email-sboyd@codeaurora.org>
 <1388709460-19222-3-git-send-email-sboyd@codeaurora.org>
 <52CB2D29.3050107@codeaurora.org>
 <52D5A266.5000504@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D5A266.5000504@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14, Stephen Boyd wrote:
> On 01/06/14 14:24, Stephen Boyd wrote:
> > On 01/02/14 16:37, Stephen Boyd wrote:
> >> Some drivers use request_any_context_irq() but there isn't a
> >> devm_* function for it. Add one so that these drivers don't need
> >> to explicitly free the irq on driver detach.
> >>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > Thomas, can you please review this patch?
> 
> ping?

ping?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
