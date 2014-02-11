Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaBKQpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:45:49 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37492 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaBKQpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:45:45 -0500
Date: Tue, 11 Feb 2014 08:39:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Add devm_request_any_context_irq()
Message-ID: <20140211163903.GD12106@core.coreip.homeip.net>
References: <1388709460-19222-3-git-send-email-sboyd@codeaurora.org>
 <tip-0668d3065128d39449c097e62dbdb5707820137d@git.kernel.org>
 <20140211064640.GG10784@codeaurora.org>
 <alpine.DEB.2.02.1402111527090.21991@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402111527090.21991@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 03:32:44PM +0100, Thomas Gleixner wrote:
> On Mon, 10 Feb 2014, Stephen Boyd wrote:
> > On 02/09, tip-bot for Stephen Boyd wrote:
> > > Commit-ID:  0668d3065128d39449c097e62dbdb5707820137d
> > > Gitweb:     http://git.kernel.org/tip/0668d3065128d39449c097e62dbdb5707820137d
> > > Author:     Stephen Boyd <sboyd@codeaurora.org>
> > > AuthorDate: Thu, 2 Jan 2014 16:37:32 -0800
> > > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > > CommitDate: Sun, 9 Feb 2014 15:27:21 +0100
> > > 
> > > genirq: Add devm_request_any_context_irq()
> > > 
> > > Some drivers use request_any_context_irq() but there isn't a
> > > devm_* function for it. Add one so that these drivers don't need
> > > to explicitly free the irq on driver detach.
> > > 
> > > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > Link: http://lkml.kernel.org/r/1388709460-19222-3-git-send-email-sboyd@codeaurora.org
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Thanks Thomas. Is this going in for 3.14? Or can Dmitry pull a
> > branch from the tip tree into the input tree so that the
> > dependent input driver patches can be applied?
> 
> tip/irq/devm contains only this commit so Dmitry can pull it in.

Unfortunately it is based on top of some random commit. If you could
create a branch off 3.14 with this commit I would be able to pull it in.

Thanks.

-- 
Dmitry
