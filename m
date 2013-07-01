Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab3GAJM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:12:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58420 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab3GAJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:12:28 -0400
Message-ID: <1372669941.7678.113.camel@marge.simpson.net>
Subject: Re: sched: context tracking demolishes pipe-test
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 01 Jul 2013 11:12:21 +0200
In-Reply-To: <20130701080638.GM6626@twins.programming.kicks-ass.net>
References: <1372579056.6607.16.camel@marge.simpson.net>
	 <20130630212940.GK6626@twins.programming.kicks-ass.net>
	 <1372658875.7678.17.camel@marge.simpson.net>
	 <20130701080638.GM6626@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:f8ZeMRviIlQ9cj/spNPMMP1EBaxz3qmF4XeGzuRIypS
 RKNptACWmllUIc++1gRToja1JvD+e+twuVf1gNH60PNrMyArd6
 oLTKPIrSFj7U9DOXxHo7rkB1aGfVq30FJ4KsLz0/uoWsnUnTTo
 CcQ0MmI+O5Et5bir9iYt0JY1GA96vEjf1Fr9INyKe9wgEH4NHe
 iAWU8kJMKH0NdHBmMB5ySGIAmAWdAhJCE0hMCStf67BEHI5jQe
 6lrxfuMJ8KAHOVIlDSWZDgous2MwTcrxguTpYIAeD1Lj5LG1PD
 eHg03HLRxCHaqHmatTs/41Y8vWmSCmiotDfZcDO/waotITBv34
 PUlTlJCVX6UViW5BqrjsqXUf5oPW9y5TaOz3Iql0fZcywFIqV2
 JIg2ZSR00lWxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 10:06 +0200, Peter Zijlstra wrote:

> So aside from the context tracking stuff, there's still a regression
> we might want to look at. That's still a ~10% drop against 2.6.32 for
> TCP_RR and few percents for tbench.

Yeah, known, and some of it's ours.

-Mike 

