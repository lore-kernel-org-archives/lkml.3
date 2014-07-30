Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaG3ItY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:49:24 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:26628
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbaG3ItH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:49:07 -0400
X-IronPort-AV: E=Sophos;i="5.01,762,1400018400"; 
   d="scan'208";a="73318770"
Date: Wed, 30 Jul 2014 10:48:43 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Alexandre Courbot <gnurou@gmail.com>
cc: Linus Walleij <linus.walleij@linaro.org>, kernel-janitors@vger.kernel.org,
        linux-ia64@vger.kernel.org, ceph-devel@vger.kernel.org,
        toralf.foerster@gmx.de, hmh@hmh.eng.br,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] gpiolib: devres: use correct structure type name in
 sizeof
In-Reply-To: <CAAVeFuLZb3CVV6B771V3-mzYdp0zsxaBfAAdikQDMBxSZTPTjA@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1407301048170.2389@hadrien>
References: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr> <1406647011-8543-7-git-send-email-Julia.Lawall@lip6.fr> <CAAVeFuLZb3CVV6B771V3-mzYdp0zsxaBfAAdikQDMBxSZTPTjA@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jul 2014, Alexandre Courbot wrote:

> On Wed, Jul 30, 2014 at 12:16 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > Correct typo in the name of the type given to sizeof.  Because it is the
> > size of a pointer that is wanted, the typo has no impact on compilation or
> > execution.
> >
> > This problem was found using Coccinelle (http://coccinelle.lip6.fr/).  The
> > semantic patch used can be found in message 0 of this patch series.
>
> Acked-by: Alexandre Courbot <acourbot@nvidia.com>
>
> Interestingly the compiler never complains despite gpiod_desc not
> being a declared type...

The compiler doesn't care.  A pointer is a pointer, regardless of the
type.

julia
