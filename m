Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965651AbaCSQHC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:07:02 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:40143 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933953AbaCSQG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:06:59 -0400
Date: Wed, 19 Mar 2014 17:07:10 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Jyri Sarha <jsarha@ti.com>
Cc: Mark Brown <broonie@kernel.org>, <alsa-devel@alsa-project.org>,
        <devicetree@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: Re: [PATCH v3 4/4] ASoC: simple-card: Add DT documentation for
 multi-DAI links
Message-ID: <20140319170710.19fc5a1d@armhf>
In-Reply-To: <53296CB7.1000909@ti.com>
References: <cover.1394883134.git.moinejf@free.fr>
	<d054780a0edf4b2338a52e48bff9144e19aa614f.1394883134.git.moinejf@free.fr>
	<20140317164339.GR11706@sirena.org.uk>
	<20140318091728.1d2240ca@armhf>
	<53296CB7.1000909@ti.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014 12:08:55 +0200
Jyri Sarha <jsarha@ti.com> wrote:

> sound {
> 	compatible = "simple-audio-card";
> 	simple-audio-card,name = "Simple Audio";
> 	simple-audio-card,widgets = ...
> 	simple-audio-card,routing = ...
> 
> 	simple-audio-card,dai-link@0 {		/* I2S - codec */
> 		format = "i2s";
> 		bitclock-master = "codec";
> 		frame-master = "codec";
> 		bitclock-inversion = <1>;
> 		simple-audio-card,cpu {
> 			sound-dai = <&audio1 0>;
> 			bitclock-inversion = <0>;
> 		};
> 		simple-audio-card,codec {
> 			sound-dai = <&codec 0>;
> 			system-clock-frequency = <12000000>;
> 		};
> 	};
> ...
> 
> I can participate in the implementation too.

Thanks. I will prepare the multi DAI links and send you the first
patches.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
