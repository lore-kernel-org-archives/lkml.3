Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbbAVIHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:07:51 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:41974 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbbAVIHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:07:40 -0500
Date: Thu, 22 Jan 2015 09:07:23 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jyri Sarha <jsarha@ti.com>
Subject: Re: [alsa-devel] [PATCH v2 3/3] ASoC: add generic dt-card support
Message-ID: <20150122090723.50ac0156@armhf>
In-Reply-To: <54C0088F.9070609@metafoo.de>
References: <cover.1421868426.git.moinejf@free.fr>
	<d0c66c2e2f200119f9990fa52a503b1a4af6238f.1421868426.git.moinejf@free.fr>
	<54C0088F.9070609@metafoo.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 21:14:07 +0100
Lars-Peter Clausen <lars@metafoo.de> wrote:

> [...]
> > +	card->dai_link->dai_fmt =
> > +		snd_soc_of_parse_daifmt(of_cpu, "dt-audio-card,",
> > +					NULL, NULL) &
> > +			~SND_SOC_DAIFMT_MASTER_MASK;
> 
> 
> This one does not seem to be in the bindings documentation.

Sorry, I forgot to remove it from the patch.

BTW, the graph of port should also contain pieces of the audio specific
hardware information as the ones found in the simple-card (clock,
GPIO, ...). This information could be written as generic device node
properties. i.e without any prefix.

I was also wondering about some of these properties, as widgets and
routing. They seem to be software information and Linux specific.
Must these properties appear in the DTs?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
