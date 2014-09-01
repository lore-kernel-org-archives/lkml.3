Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaIANko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:40:44 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:42660 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbaIANkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:40:42 -0400
Date: Mon, 1 Sep 2014 15:34:12 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        kuninori.morimoto.gx@renesas.com, moinejf@free.fr, andrew@lunn.ch,
        jsarha@ti.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        alsa-devel@alsa-project.org, shawn.guo@freescale.com,
        linux-kernel@vger.kernel.org, Nicolin Chen <nicoleotsuka@gmail.com>
Subject: Re: [PATCHv1 1/7] ASoC: simple-card: Merge single and muti DAI link
 code.
Message-ID: <20140901133412.GA11312@lunn.ch>
References: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
 <1409545781-20530-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409545781-20530-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 12:29:35PM +0800, Xiubo Li wrote:
> This patch merge single DAI link and muti-DAI links code together,
> and simply the simple-card driver code.

Hi Xiubo

It would be good to note that this breaks the Binary API with DT
blobs. Old blobs will not work with this new C code.

> And also do some other improvement:

It would be good to put these improvements into separate patches,
making them easier to review.

> +====
> +DAI link node(s) and its or their subnodes:
>  
> -Required dai-link subnodes:
> +There must be one DAI link node exsit at least, and each DAI link must

typ0. It would also be better to say:

There must be at least one DAI link, and each DAI link must

> +contain one CPU subnode and one CODEC subnode.

  Andrew
