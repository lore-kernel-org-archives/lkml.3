Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaHRBch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 21:32:37 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10310 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372AbaHRBcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 21:32:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18mbGtZxesb6Q8y7uf6rm23Ql4olID3N54=
X-DKIM: OpenDKIM Filter v2.0.1 titan 1A21C5C838D
Date: Sun, 17 Aug 2014 21:32:24 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v4] irqchip: gic: Allow gic_arch_extn hooks to call
 into scheduler
Message-ID: <20140818013224.GM12769@titan.lakedaemon.net>
References: <1407938238-21413-1-git-send-email-sboyd@codeaurora.org>
 <20140817173236.GG12769@titan.lakedaemon.net>
 <20140817185522.GX30401@n2100.arm.linux.org.uk>
 <20140817190434.GJ12769@titan.lakedaemon.net>
 <20140817214123.GY30401@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817214123.GY30401@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 10:41:23PM +0100, Russell King - ARM Linux wrote:
> On Sun, Aug 17, 2014 at 03:04:34PM -0400, Jason Cooper wrote:
> > Quoting Nico:
> > 
> > "Of course it would be good to clarify things wrt Russell's remark
> > independently from this patch."
> > 
> > I took 'independently' to mean "This patch is ok, *and* we need to
> > address Russell's concerns in a follow-up patch."
> > 
> > Nico's Reviewed-by with that comment was sent August 13th.  The most
> > recent activity on this thread was also August 13th.  After four days, I
> > reasoned there were no objections to his comment.
> 
> Right, during the merge window, and during merge windows, I tend to
> ignore almost all email now because people don't stop developing, and
> they don't take any notice where the mainline cycle is.  In fact, I go
> off and do non-kernel work during a merge window and only briefly scan
> for bug fixes.

Ok, now dropped.

thx,

Jason.
