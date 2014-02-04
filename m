Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbaBDTC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:02:27 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:44914 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188AbaBDTCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:02:25 -0500
Date: Tue, 4 Feb 2014 20:02:39 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 3/5] ASoC: tda998x: add DT documentation of the
 tda998x CODEC
Message-ID: <20140204200239.1baf309b@armhf>
In-Reply-To: <20140204181213.GO22609@sirena.org.uk>
References: <cover.1391274627.git.moinejf@free.fr>
	<8e4231b7a55802f58a14dd07ac5cd8b0babb1dce.1391274628.git.moinejf@free.fr>
	<20140204181213.GO22609@sirena.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014 18:12:13 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Sat, Feb 01, 2014 at 05:48:49PM +0100, Jean-Francois Moine wrote:
> 
> > +	- compatible: must be "nxp,tda998x-codec".
> 
> It's not clear to me why there's a separate compatible here - as far as
> I can see this can only appear as part of one of these devices and
> there's no addressing or other information that'd account for chip
> variation so I'd not expect to need to bind this independently of the
> parent.

If there is no 'compatible', the CODEC module is not loaded, and, when
the module is in the core, no CODEC device can be created from the DT.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
