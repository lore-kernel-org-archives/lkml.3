Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3HLUZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:25:19 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:25374
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728Ab3HLUZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:25:17 -0400
X-IronPort-AV: E=Sophos;i="4.89,864,1367964000"; 
   d="scan'208";a="23795740"
Date: Mon, 12 Aug 2013 22:24:59 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Eric Miao <eric.y.miao@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 9/16] arch/arm/mach-pxa/mioa701.c: Avoid using
 ARRAY_AND_SIZE(e) as a function argument
In-Reply-To: <87r4dyy93t.fsf@free.fr>
Message-ID: <alpine.DEB.2.02.1308122224430.2128@localhost6.localdomain6>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr> <1376239917-15594-10-git-send-email-Julia.Lawall@lip6.fr> <87r4dyy93t.fsf@free.fr>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013, Robert Jarzmik wrote:

> Julia Lawall <Julia.Lawall@lip6.fr> writes:
> 
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
> > arity of the called function.
> 
> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
> 
> As a side I'm curious why this change didn't touch also :
> sound/soc/pxa/mioa701_wm9713.c
> 
> If it does, this ack stands as well for the other file (with removal of the
> #define in mioa701_wm9713.c).

I'll check.  Thanks for the feedback.

julia
