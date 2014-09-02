Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaIBKhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:37:39 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:14314 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaIBKhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:37:38 -0400
Date: Tue, 2 Sep 2014 12:38:48 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, broonie@kernel.org, perex@perex.cz,
        lgirdwood@gmail.com, tiwai@suse.de, andrew@lunn.ch,
        kuninori.morimoto.gx@renesas.com, jsarha@ti.com,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/4] ASoC: simple-card: add
 asoc_simple_card_fmt_master() to simplify the code.
Message-ID: <20140902123848.78c4c62a@armhf>
In-Reply-To: <54059A35.3020303@gmail.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
	<1409649969-15759-2-git-send-email-Li.Xiubo@freescale.com>
	<54059A35.3020303@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2014 15:51:41 +0530
Varka Bhadram <varkabhadram@gmail.com> wrote:

> > +	switch (((np == bitclkmaster) << 4) | (np == framemaster)) {
> > +	case 0x11:
> > +		return SND_SOC_DAIFMT_CBS_CFS;
> > +	case 0x10:
> > +		return SND_SOC_DAIFMT_CBS_CFM;
> > +	case 0x01:
> > +		return SND_SOC_DAIFMT_CBM_CFS;
> > +	default:
> > +		return SND_SOC_DAIFMT_CBM_CFM;
> > +	}
> > +
> > +	/* Shouldn't be here */
> > +	return -EINVAL;
> > +}  
> 
> It will be nice if we declare the switch case numbers as macros (specific name)...

I don't see which macros: the values are just 2 booleans.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
