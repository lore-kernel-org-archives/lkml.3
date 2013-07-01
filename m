Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3GAJVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:21:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab3GAJVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:21:04 -0400
Message-ID: <1372670432.7678.114.camel@marge.simpson.net>
Subject: Re: sched: context tracking demolishes pipe-test
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 01 Jul 2013 11:20:32 +0200
In-Reply-To: <1372669941.7678.113.camel@marge.simpson.net>
References: <1372579056.6607.16.camel@marge.simpson.net>
	 <20130630212940.GK6626@twins.programming.kicks-ass.net>
	 <1372658875.7678.17.camel@marge.simpson.net>
	 <20130701080638.GM6626@twins.programming.kicks-ass.net>
	 <1372669941.7678.113.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Xcz0ZdA3nBMs87K1JxGbRdRaEd7oMrgnyDuFhgTPg22
 L3SxPtGDae8vC7h25G7t2Lp7krfT47qWZINxiFS8dwQzvXyBGV
 1RVsKzedBmk9UjruFNewLiAUcb5ZVqa+8I3YlEajXTaYJ4Hnk5
 s4YSISiv0U1FtkVfa4lv1QkiCooqyiivYU0sAKtS6/HpktRiYE
 jx45ltbCrW8/2Xz1tV/a+l62OnJ7ULOfBdNZKySs/CGMSNLdUj
 kxsrm7DpttafKPLMmKFjuYSkGg4/lRAaHb+58u/6K24NAlfdAD
 vK7iEOvpuGgxzFAxDSbrrVib5dleUlloZHJbUtDlGVTLrPHKnT
 AMKqK053O3MPrrKhJYbUMIct8YYUZIVsVqPPrwt5t3aJJixF0a
 NlrXDTmecwdYQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 11:12 +0200, Mike Galbraith wrote: 
> On Mon, 2013-07-01 at 10:06 +0200, Peter Zijlstra wrote:
> 
> > So aside from the context tracking stuff, there's still a regression
> > we might want to look at. That's still a ~10% drop against 2.6.32 for
> > TCP_RR and few percents for tbench.
> 
> Yeah, known, and some of it's ours.

(btw tbench has a ~5% phase-of-moon jitter, you can pretty much
disregard that one)

