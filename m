Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaIBKkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:40:01 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:21454 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbaIBKj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:39:58 -0400
Date: Tue, 2 Sep 2014 12:41:14 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: <broonie@kernel.org>, <perex@perex.cz>, <lgirdwood@gmail.com>,
        <tiwai@suse.de>, <andrew@lunn.ch>, <kuninori.morimoto.gx@renesas.com>,
        <jsarha@ti.com>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 4/4] ASoC: simple-card: binding: update binding to
 support the new style.
Message-ID: <20140902124114.6d95e0c5@armhf>
In-Reply-To: <1409649969-15759-5-git-send-email-Li.Xiubo@freescale.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
	<1409649969-15759-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014 17:26:09 +0800
Xiubo Li <Li.Xiubo@freescale.com> wrote:

> +Example 4 - many DAI links:
>  sound {
>  	compatible = "simple-audio-card";
>  	simple-audio-card,name = "Cubox Audio";
> @@ -128,6 +195,7 @@ sound {
>  		};
>  		codec {
>  			sound-dai = <&tda998x 0>;
> +			frame-inversion;
>  		};
>  	};

This is not useful: there is no clock/frame handling in the kirkwood
audio controller.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
