Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaAWNA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:00:28 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:45515 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaAWNA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:00:27 -0500
MIME-Version: 1.0
In-Reply-To: <b073a0513dd04d4b99177b2f2c3a8eb5@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1390463283-7545-1-git-send-email-Li.Xiubo@freescale.com>
	<CAOMZO5ATVkcORZBMbNzu2F-dyJxjzgjkRgezj2vGM9v7cyfy1w@mail.gmail.com>
	<b073a0513dd04d4b99177b2f2c3a8eb5@BY2PR03MB505.namprd03.prod.outlook.com>
Date: Thu, 23 Jan 2014 11:00:26 -0200
Message-ID: <CAOMZO5AMiQF=QgxuTvmOi49dC+er4L6a42F-daab3dEsQZB+yA@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl-sai: convert to use regmap API for
 Freeacale SAI
From: Fabio Estevam <festevam@gmail.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Timur Tabi <timur@tabi.org>,
        "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 8:32 AM, Li.Xiubo@freescale.com
<Li.Xiubo@freescale.com> wrote:

> The clock operations in the driver is only related to the module clock, and has
> move to the regmap core and regmap core will to the same clock operations at
> proper time, since we are using:
>
> +       sai->regmap = devm_regmap_init_mmio_clk(&pdev->dev,
> +                       "sai", base, &fsl_sai_regmap_config);

Ok, understood. I was not familiar with devm_regmap_init_mmio_clk()

Regards,

Fabio Estevam
