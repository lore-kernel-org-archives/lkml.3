Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab3GWPer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:34:47 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:49456 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757721Ab3GWPeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:34:46 -0400
Date: Tue, 23 Jul 2013 17:34:50 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [alsa-devel] [PATCH v3] ARM: kirkwood: extend the kirkwood i2s
 driver for DT usage
Message-ID: <20130723173450.0d67036b@armhf>
In-Reply-To: <51EE8591.7060005@gmail.com>
References: <20130723104615.3696f1a9@armhf>
	<20130723123444.GW9858@sirena.org.uk>
	<51EE7E1A.3040301@gmail.com>
	<20130723132016.GC9858@sirena.org.uk>
	<51EE8591.7060005@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013 15:30:57 +0200
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> >> again, we mentioned to merge kirkwood-i2s.c and kirkwood-dma.c into
> >> a single file, didn't we?  
> >
> > That's been discussed several times but nobody's actually done it.  
> 
> Correct, that is why I repeated that request to Jean-Francois.

Thanks for all your remarks.

I am testing a new version, with mainly:
- "internal" and "external" clocks
- kirkwood-i2s and kirkwood-dma in one module
- no S/PDIF (I have not yet tried i2s with the tda998x)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
