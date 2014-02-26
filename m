Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaBZKCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:02:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:59462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaBZKCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:02:16 -0500
Message-ID: <1393408924.5592.6.camel@marge.simpson.net>
Subject: Re: [PATCH] sched/rt: fix rt timer activation/deactivation
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tkhai@yandex.ru, Juri Lelli <juri.lelli@gmail.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 11:02:04 +0100
In-Reply-To: <20140226090700.GG18404@twins.programming.kicks-ass.net>
References: <1393344328-16653-1-git-send-email-juri.lelli@gmail.com>
	 <1393361805.12438.6.camel@HP-250-G1-Notebook-PC>
	 <1393382258.5142.4.camel@marge.simpson.net>
	 <20140226090700.GG18404@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:4y4NlW71WqYVK2q372nl519AtP5bhdVsMCeExe1A+iD
 v7HEx2xK4ns6OYFpv575d+b23/RjudX+sq1vJYkRH06cbWbdJY
 i5VCsz1E6bw/QOlJAAzyd2w1NLp42nmI/dBxhYGJ/YhgSbDcUA
 bQp7hCo6TwojKd1/7aStEiUPJqpxfYNjsyT8grsKuV6HH8Fzmv
 tTOuNsgs8GI9mJdfxdl37gc6dEyuHV7MESz8ZAcWGNtJqUxTh5
 7+yLPV3vYsOk0UmDacIrSGvqbXYwk/9p/zkOk9jsT1KETh0lgj
 C/RJwWTaseuSgunT+dP1qzMs9gd4MeB4tWrrHoAt3dlxMiN/X/
 2F4YG0wByt4wZ/SHbXRSvjZxUzblfw0UTl00LutZRMvYDIVjQf
 j+vQa1/UJ673A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-26 at 10:07 +0100, Peter Zijlstra wrote: 
> On Wed, Feb 26, 2014 at 03:37:38AM +0100, Mike Galbraith wrote:
> > BTW, I noticed you can no longer turn the turn the noisy thing off since
> > we grew DL.  I added an old SGI boot parameter to tell it to go away.
> 
> You're talking about the rt badnwidth timer, right?

Right.

> 1) why won't it go away with DL added?

Hm, it _was_ saying go away when I said -1, but 7472e009a3f1 is obeying,
so I guess it got fixed.. so never mind.

-Mike

