Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaBKHTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:19:24 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33024 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaBKHTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:19:19 -0500
Date: Tue, 11 Feb 2014 08:19:15 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Add devm_request_any_context_irq()
Message-ID: <20140211071915.GB23646@gmail.com>
References: <1388709460-19222-3-git-send-email-sboyd@codeaurora.org>
 <tip-0668d3065128d39449c097e62dbdb5707820137d@git.kernel.org>
 <20140211064640.GG10784@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211064640.GG10784@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Boyd <sboyd@codeaurora.org> wrote:

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
> branch from the tip tree into the input tree so that the dependent 
> input driver patches can be applied?

So irq/core would normally be for v3.15 - but the commit provides 
pretty standlone core functionality that cannot possibly break, so if 
Thomas agrees I'd not be against making an exception and moving this 
into v3.14 via irq/urgent.

Thanks,

	Ingo
