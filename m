Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3CAIgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:36:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54456 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3CAIgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:36:41 -0500
Date: Fri, 1 Mar 2013 09:36:24 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Vinicius Tinti <viniciustinti@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] arm: remove extra semicolon in if statement
Message-ID: <20130301083624.GI22886@pengutronix.de>
References: <1362111952-8072-1-git-send-email-viniciustinti@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1362111952-8072-1-git-send-email-viniciustinti@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Mar 01, 2013 at 01:25:52AM -0300, Vinicius Tinti wrote:
> Remove extra semicolon in perf_event.c if statement.
The commit log sounds like a style fix, but your patch introduces a
semantical change. I suspect this patch fixes a real bug, you should
point that out here.

Best regards
Uwe
> 
> Signed-off-by: Vinicius Tinti <viniciustinti@gmail.com>
> ---
>  arch/arm/kernel/perf_event.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index 31e0eb3..a892067 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -400,7 +400,7 @@ __hw_perf_event_init(struct perf_event *event)
>  	}
>  
>  	if (event->group_leader != event) {
> -		if (validate_group(event) != 0);
> +		if (validate_group(event) != 0)
>  			return -EINVAL;
>  	}
>  
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
