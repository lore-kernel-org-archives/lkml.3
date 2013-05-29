Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164Ab3E2ITn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:19:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:54821 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965152Ab3E2ITk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:19:40 -0400
Date: Wed, 29 May 2013 10:19:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@linaro.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Try out the irqdomain + generic chip integration
 series
In-Reply-To: <1369793454-19197-1-git-send-email-grant.likely@linaro.org>
Message-ID: <alpine.LFD.2.02.1305291017070.2995@ionos>
References: <1369793454-19197-1-git-send-email-grant.likely@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

On Wed, 29 May 2013, Grant Likely wrote:

> Hi Thomas,
> 
> Rather than just straight reviewing the generic irq chip patch series, I
> tried it out by converting another driver to use it. As far as I've been
> able to tell it does the right thing and you can have my ack. The first
> patch in this series adds another feature needed by the versatile
> driver. Patch 2 should be okay, but I'd like to get an ack from Ben
> before it gets applied.

I pick up #1 and push it with the other lot, so people can start
working on top of that. I'll put it into a separate branch
(irq/for-arm) so SoC folks can grab it from there to avoid inter tree
dependencies.
 
> I need to get someone to test patch 3 on hardware before you pick up
> that one.

Sure. It might also go through the SoC tree(s).
 
> Oh, and I'll reply directly to patch 7 of your series with an ack and a
> minor comment.

Thanks,

	tglx
