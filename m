Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3IOVYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 17:24:00 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50287 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3IOVX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 17:23:59 -0400
Date: Sun, 15 Sep 2013 23:23:58 +0200
From: Andreas Mohr <andi@lisas.de>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Andreas Mohr <andi@lisas.de>, alsa-devel@alsa-project.org,
        krzysztof.h1@wp.pl,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] ES938 support for ES18xx driver
Message-ID: <20130915212358.GB32375@rhlx01.hs-esslingen.de>
References: <20130915184902.GA23480@rhlx01.hs-esslingen.de>
 <201309152225.46581.linux@rainbow-software.org>
 <20130915203520.GA10589@rhlx01.hs-esslingen.de>
 <201309152304.27585.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309152304.27585.linux@rainbow-software.org>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 11:04:26PM +0200, Ondrej Zary wrote:
> On Sunday 15 September 2013 22:35:20 Andreas Mohr wrote:
> > What!?!? I didn't quite expect any kernel dev to have that one, too ;)
> 
> Don't remember where I got it from but it looked nice so I bought it :)

Yup, e.g. the builtin amp is quite nice.

> > Thanks for hinting at the TLV control dB values thingy! Didn't know that
> > such thing existed, thus azt3328 does not have it (yet?).
> 
> It's a nice thing, especially for cards that can go above 0 dB. You then know 
> that the sound can be distorted when you set e.g. PCM volume too high.

Hmm, any hint how to precisely do dB values normalization scaling,
for a card where this is not documented? Or perhaps that's actually easy -
haven't thought about it...

> > Is there any chip ID/version register to be identified?
> 
> No, there are only 8 registers, all(? - haven't tested) R/W.

OK, but possibly they happen to be creating another virtual register mapping range?
(i.e. index/data register combo?)

Andreas Mohr
