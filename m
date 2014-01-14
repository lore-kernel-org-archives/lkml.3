Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaANLJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:09:49 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:49644 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbaANLJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:09:47 -0500
Date: Tue, 14 Jan 2014 12:09:13 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [alsa-devel] [RFC][PATCH] ASoC: simple-card: Add
 asoc_simple_card_data for the simple card driver data
Message-ID: <20140114120913.19d883fe@armhf>
In-Reply-To: <96cb876ff05c4062ab5a2c92fb7b3c41@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1389678282-1097-1-git-send-email-Li.Xiubo@freescale.com>
	<871u0bgiai.wl%kuninori.morimoto.gx@gmail.com>
	<96cb876ff05c4062ab5a2c92fb7b3c41@BY2PR03MB505.namprd03.prod.outlook.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 07:56:32 +0000
"Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com> wrote:

> 
> > > Whether the dt is used or not, almost all the simple card information
> > > for the DAI link and sound card are initialized in the simple card driver.
> > >
> > > And for the platform caller, the snd_link and snd_card are of no use, so
> > > move them from struct asoc_simple_card_info to struct asoc_simple_card_data.
> > >
> > > And now only one DAI link is supported for simple card.
> > >
> > > Suggested-by: Jean-Francois Moine <moinejf@free.fr>
> > > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > > ---
> > 
> > This patch seems have many this kind of lines
> >   -	info->xxx
> >   +	sdata->info->xxx
> > 
> > But, how about add this line to each function ?
> > 
> >      struct asoc_simple_card_info *info = &sdata->info;
> > 
> > Patch will be more readable
> >
> 
> Yes, that's looks perfect.
> 
> See the next version please.

Please, don't work on an other version. I am preparing an other patch which will do quite the same as yours, but which will be easier to extend to many DAI links.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
