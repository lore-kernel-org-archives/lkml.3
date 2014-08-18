Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaHRAEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 20:04:50 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:57161 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaHRAEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 20:04:48 -0400
Date: Sun, 17 Aug 2014 20:04:45 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] irqchip: gic: Allow gic_arch_extn hooks to call into
 scheduler
In-Reply-To: <20140817190434.GJ12769@titan.lakedaemon.net>
Message-ID: <alpine.LFD.2.11.1408172000460.29347@knanqh.ubzr>
References: <1407938238-21413-1-git-send-email-sboyd@codeaurora.org> <20140817173236.GG12769@titan.lakedaemon.net> <20140817185522.GX30401@n2100.arm.linux.org.uk> <20140817190434.GJ12769@titan.lakedaemon.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2014, Jason Cooper wrote:

> Russell,
> 
> On Sun, Aug 17, 2014 at 07:55:23PM +0100, Russell King - ARM Linux wrote:
> > On Sun, Aug 17, 2014 at 01:32:36PM -0400, Jason Cooper wrote:
> > > Applied to irqchip/urgent with Nico's Ack.
> > 
> > Interesting, so I'm discussing this patch, and it gets applied anyway...
> > yes, that's great.
> 
> Quoting Nico:
> 
> "Of course it would be good to clarify things wrt Russell's remark
> independently from this patch."
> 
> I took 'independently' to mean "This patch is ok, *and* we need to
> address Russell's concerns in a follow-up patch."
> 
> Nico's Reviewed-by with that comment was sent August 13th.  The most
> recent activity on this thread was also August 13th.  After four days, I
> reasoned there were no objections to his comment.

Well... I mentioned this patch is a nice cleanup independently of the 
reason why it was created in the first place.  Maybe that shouldn't be 
sorted as "urgent" in that case, especially when the code having problem 
with the current state of things is living out of mainline.


Nicolas
