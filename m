Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014AbaBKOcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:32:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:42198 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaBKOcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:32:45 -0500
Date: Tue, 11 Feb 2014 15:32:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Add devm_request_any_context_irq()
In-Reply-To: <20140211064640.GG10784@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1402111527090.21991@ionos.tec.linutronix.de>
References: <1388709460-19222-3-git-send-email-sboyd@codeaurora.org> <tip-0668d3065128d39449c097e62dbdb5707820137d@git.kernel.org> <20140211064640.GG10784@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014, Stephen Boyd wrote:
> On 02/09, tip-bot for Stephen Boyd wrote:
> > Commit-ID:  0668d3065128d39449c097e62dbdb5707820137d
> > Gitweb:     http://git.kernel.org/tip/0668d3065128d39449c097e62dbdb5707820137d
> > Author:     Stephen Boyd <sboyd@codeaurora.org>
> > AuthorDate: Thu, 2 Jan 2014 16:37:32 -0800
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Sun, 9 Feb 2014 15:27:21 +0100
> > 
> > genirq: Add devm_request_any_context_irq()
> > 
> > Some drivers use request_any_context_irq() but there isn't a
> > devm_* function for it. Add one so that these drivers don't need
> > to explicitly free the irq on driver detach.
> > 
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Link: http://lkml.kernel.org/r/1388709460-19222-3-git-send-email-sboyd@codeaurora.org
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Thanks Thomas. Is this going in for 3.14? Or can Dmitry pull a
> branch from the tip tree into the input tree so that the
> dependent input driver patches can be applied?

tip/irq/devm contains only this commit so Dmitry can pull it in.

Thanks,

	tglx
