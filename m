Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3KAKrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:47:46 -0400
Received: from skyrme.org ([193.175.80.135]:34198 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab3KAKrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:47:45 -0400
X-Greylist: delayed 1783 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Nov 2013 06:47:45 EDT
Date: 1 Nov 2013 10:17:50 +0000
Message-ID: <20131101101750.GB16492@curry>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Xiubo Li" <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, timur@tabi.org, lgirdwood@gmail.com,
        broonie@kernel.org, r64188@freescale.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ian.campbell@citrix.com, rob@landley.net, linux@arm.linux.org.uk,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        fabio.estevam@freescale.com, LW@KARO-electronics.de,
        shawn.guo@linaro.org, b42378@freescale.com, b18965@freescale.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCHv2 6/8] ASoC: fsl: add SGTL5000 based audio machine driver.
References: <1383289495-24523-1-git-send-email-Li.Xiubo@freescale.com> <1383289495-24523-7-git-send-email-Li.Xiubo@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383289495-24523-7-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.4.2.3i
Organisation: www.embedded-group.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not that it would improve functionality, but:

On Fri, Nov 01, 2013 at 15:04:53 +0800, Xiubo Li wrote:
[...]
> diff --git a/sound/soc/fsl/fsl-sgtl5000-vf610.c b/sound/soc/fsl/fsl-sgtl5000-vf610.c
> new file mode 100644
> index 0000000..f535b42
> --- /dev/null
> +++ b/sound/soc/fsl/fsl-sgtl5000-vf610.c
> @@ -0,0 +1,208 @@
> +/*
> + * Freeacale ALSA SoC Audio using SGT1500 as codec.
          ^                             ^   ^
     "Freescale"                    "SGTL5000"

regards,
  Oskar
