Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaIBKnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:43:23 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:31548 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbaIBKnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:43:22 -0400
Date: Tue, 2 Sep 2014 12:44:38 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: <broonie@kernel.org>, <perex@perex.cz>, <lgirdwood@gmail.com>,
        <tiwai@suse.de>, <andrew@lunn.ch>, <kuninori.morimoto.gx@renesas.com>,
        <jsarha@ti.com>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 3/4] ASoC: simple-card: Adjust the comments of simple
 card.
Message-ID: <20140902124438.36da4b85@armhf>
In-Reply-To: <1409649969-15759-4-git-send-email-Li.Xiubo@freescale.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
	<1409649969-15759-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014 17:26:08 +0800
Xiubo Li <Li.Xiubo@freescale.com> wrote:

> @@ -285,11 +287,11 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
>  		dai_props->codec_dai.sysclk);
>  
>  	/*
> -	 * soc_bind_dai_link() will check cpu name
> -	 * after of_node matching if dai_link has cpu_dai_name.
> -	 * but, it will never match if name was created by fmt_single_name()
> -	 * remove cpu_dai_name to escape name matching.
> -	 * see
> +	 * In soc_bind_dai_link() will check cpu name after
> +	 * of_node matching if dai_link has cpu_dai_name.
> +	 * but, it will never match if name was created by
> +	 * fmt_single_name() remove cpu_dai_name to escape
> +	 * name matching. Please see:
>  	 *	fmt_single_name()
>  	 *	fmt_multiple_name()
>  	 */

The patch done by Kuninori, setting the cpu_dai_name to NULL in all
cases, does not work. This sequence should be replaced where is was
previously.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
