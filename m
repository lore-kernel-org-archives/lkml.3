Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3LaMhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 07:37:13 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:48232 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab3LaMhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 07:37:11 -0500
Date: Tue, 31 Dec 2013 13:36:10 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: generic: add generic compound card with DT
 support
Message-ID: <20131231133610.2d14bc29@armhf>
In-Reply-To: <20131231115927.GK31886@sirena.org.uk>
References: <20131231113138.102044cf@armhf>
	<20131231115927.GK31886@sirena.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Dec 2013 11:59:27 +0000
Mark Brown <broonie@kernel.org> wrote:

> > This code was first developped on the generic simple card, but its
> > recent DT extension cannot be easily extended again to support compound
> > cards as the one in the Cubox.  
> 
> It would have been useful to have provided that feedback at the time
> rather than waiting until after it had been merged - it was in review
> for long enough.  It would also be good to articulate the issues with
> the binding rather than simply stating they exist, and to consider
> adding a second binding to the existing generic card rather than adding
> a totally new card.

Sorry, I spent a lot of time on DPCM, and I was not yet ready to propose
something when you accepted Kuninori's patch.

> Please also remember that all DT patches need to be reviewed by the DT
> people, you've not CCed either them or the list.
> 
> > +  - front-end or back-end: present if the DAI link describes resp.
> > +		a front-end CPU DAI or a back-end CODEC DAI  
> 
> These are Linux-internal concepts which shouldn't appear in a DT binding
> or at the very least need definition.  One thing to consider here is
> that these things are all about the internals of a SoC and you'd
> therefore expect that they would be defined separately from the card so
> as to avoid having to replicate information in every card using a given
> SoC.

Do you mean that, as DPCM cannot be in the DT, there should be a
specific driver for the Cubox audio card (Marvell Armada 510 + NXP HDMI
transmitter)?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
