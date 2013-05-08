Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3EHLE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:04:58 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:35673 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3EHLE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:04:56 -0400
Date: Wed, 8 May 2013 12:04:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH v2 2/6] ASoC: ux500: Do not clear state if already idle
Message-ID: <20130508110451.GC3459@gmail.com>
References: <20130508080448.GG3102@gmail.com>
 <1368002354-15471-1-git-send-email-fabio.baltieri@linaro.org>
 <20130508103401.GX7478@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130508103401.GX7478@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 May 2013, Mark Brown wrote:

> On Wed, May 08, 2013 at 10:39:14AM +0200, Fabio Baltieri wrote:
> > As enable_msp gets called only after some audio data has been received,
> > if the userspace closes the device before sending any data it causes
> > ux500_msp_i2s_close to clear device state even if it was not previously
> > initialized.
> 
> Ugh, please don't do stuff like this - you're posting an individual
> revision of a patch buried in the middle of a thread.  This just makes
> things hard to follow and error prone.  Repost the patch series

It's so much more convenient to do it this way. Re-sending entire
patch-sets for small fixups is clumsy and annoying at best. Creating
much more churn than is actually required. Sending patches again
signally i.e. not as a reply to the original [PATCH x/x], would be
even more prone to error.

Personally, I like to get the niggles and fixups out of the way using
this method, then send the entire patch-set again, complete with all
of the reaped Acks once there are significant fixes or when I believe
it to be finished and ready for applying.

Surely most people have their mail setup as threaded? Then the
time-line and subsequent patch versions are very easy to follow aren't
they? I get a nice trace like this:

> <date> Fabio Baltieri    (  0) ├>[PATCH 2/6] ASoC: ux500: <snip>
> <date> To Fabio Baltieri (  0) │└>
> <date> Fabio Baltieri    (  0) │ └>[PATCH v2 2/6] ASoC:   <snip>

... or even better would be to reply to the original one, then
subsequent versions won't be "buried in the thread" per say:

> <date> Fabio Baltieri    (  0) ├>[PATCH 2/6] ASoC: ux500: <snip>
> <date> Fabio Baltieri    (  0) │ └>[PATCH v2 2/6] ASoC:   <snip>
> <date> To Fabio Baltieri (  0) │->

> or wait until what can be applied is applied then repost.

Taking patches out-of-order, or 'willy-nilly', is asking for trouble.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
