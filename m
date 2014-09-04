Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbaIDX2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 19:28:41 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60734 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750974AbaIDX2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 19:28:40 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Anand Moon <moon.linux@yahoo.com>, viresh.kumar@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq_opp: Fixed the order of argument for kcalloc.
Date: Fri, 05 Sep 2014 01:48 +0200
Message-ID: <156662991.4EXBqE3pLR@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5408D4A5.5040103@codeaurora.org>
References: <1408180966-15493-1-git-send-email-moon.linux@yahoo.com> <5408D4A5.5040103@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 04, 2014 02:07:49 PM Stephen Boyd wrote:
> On 08/16/14 02:22, Anand Moon wrote:
> > These changes fix the argument to the kcalloc
> >         @n: number of elements.
> >         @size: element size.
> >         @flags: the type of memory to allocate (see kmalloc).
> >
> >         void *kcalloc(size_t n, size_t size, gfp_t flags)
> >
> > Signed-off-by: Anand Moon <moon.linux@yahoo.com>
> > ---
> 
> Oops.
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Can this be picked up?

It could be if I could find it.  Which is not the case, unfortunately.

Anybody care to resend it?

Rafael

