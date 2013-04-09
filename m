Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789Ab3DIDpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:45:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55702 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761958Ab3DIDpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:45:35 -0400
Message-ID: <1365479133.6865.1.camel@joe-AO722>
Subject: Re: [PATCH 1/1] irqchip: exynos-combiner: Fix checkpatch warnings
From: Joe Perches <joe@perches.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, patches@linaro.org,
        chanho61.park@samsung.com, kgene.kim@samsung.com
Date: Mon, 08 Apr 2013 20:45:33 -0700
In-Reply-To: <CAK9yfHwY5Ey28mveHtYcCvcEyiM=W2Gwpw_ybx44JT=cSm2NOw@mail.gmail.com>
References: <1363165944-7480-1-git-send-email-sachin.kamat@linaro.org>
	 <CAK9yfHzvJ+5voHuJLCNb55yB0x5R8LS=FqoCu9tn5bSXZ_BNsQ@mail.gmail.com>
	 <1365476945.2012.2.camel@joe-AO722>
	 <CAK9yfHwY5Ey28mveHtYcCvcEyiM=W2Gwpw_ybx44JT=cSm2NOw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 09:06 +0530, Sachin Kamat wrote:
> On 9 April 2013 08:39, Joe Perches <joe@perches.com> wrote:
> > On Tue, 2013-04-09 at 08:33 +0530, Sachin Kamat wrote:
> >> On 13 March 2013 14:42, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> >> > Fixes the following warnings:
> >> > WARNING: line over 80 characters
> >> > WARNING: Prefer pr_warn(... to pr_warning(...
> >> > diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
> > []
> >> > @@ -229,13 +229,15 @@ void __init combiner_init(void __iomem *combiner_base,
> > []
> >> > -               pr_warning("%s: irq desc alloc failed. Continuing with %d as linux irq base\n", __func__, irq_base);
> >> > +               pr_warn("%s: irq desc alloc failed. "
> >> > +                       "Continuing with %d as linux irq base\n",
> >> > +                       __func__, irq_base);
> >
> > Please don't split formats.
> > See Documentation/CodingStyle Chapter 2
> >
> >                 pr_warn("%s: irq desc alloc failed. Continuing with %d as linux irq base\n",
> >                         __func__, irq_base);
> >
> >
> 
> Thanks for pointing out. If I didn't split it, it would have exceeded
> the 80 column limit.

So?

> Since there were 2 different sentences, I thought
> grepping should not be a problem if split at sentence boundaries.

I think it's OK to split at \n but not necessarily
at a sentence boundary/period.


