Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab3CAJQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:16:09 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40335 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709Ab3CAJQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:16:06 -0500
Date: Fri, 1 Mar 2013 09:15:08 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Vinicius Tinti <viniciustinti@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] arm: remove extra semicolon in if statement
Message-ID: <20130301091508.GB27385@e106331-lin.cambridge.arm.com>
References: <1362111952-8072-1-git-send-email-viniciustinti@gmail.com>
 <20130301083624.GI22886@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130301083624.GI22886@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 08:36:24AM +0000, Uwe Kleine-König wrote:
> Hello,
> 
> On Fri, Mar 01, 2013 at 01:25:52AM -0300, Vinicius Tinti wrote:
> > Remove extra semicolon in perf_event.c if statement.
> The commit log sounds like a style fix, but your patch introduces a
> semantical change. I suspect this patch fixes a real bug, you should
> point that out here.
> 
> Best regards
> Uwe

It does fix a real bug, but Will already has a fix [1]. It's in rmk's patch
tracking system as 7664/1.

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/151564.html

> > 
> > Signed-off-by: Vinicius Tinti <viniciustinti@gmail.com>
> > ---
> >  arch/arm/kernel/perf_event.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> > index 31e0eb3..a892067 100644
> > --- a/arch/arm/kernel/perf_event.c
> > +++ b/arch/arm/kernel/perf_event.c
> > @@ -400,7 +400,7 @@ __hw_perf_event_init(struct perf_event *event)
> >  	}
> >  
> >  	if (event->group_leader != event) {
> > -		if (validate_group(event) != 0);
> > +		if (validate_group(event) != 0)
> >  			return -EINVAL;
> >  	}
> >  
> > -- 
> > 1.7.9.5
> > 
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > 
> 
> -- 
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
