Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbaIINZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:25:39 -0400
Received: from muin.pair.com ([209.68.1.55]:57684 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbaIINZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:25:38 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 09:25:38 EDT
Message-ID: <540EFDFF.7050804@tabi.org>
Date: Tue, 09 Sep 2014 08:17:51 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Shengjiu Wang <shengjiu.wang@freescale.com>, nicoleotsuka@gmail.com,
        Li.Xiubo@freescale.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de
CC: alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
In-Reply-To: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shengjiu Wang wrote:
> +	if (ssi_private->soc->imx)
> +		clk_prepare_enable(ssi_private->clk);

How about this instead?

if (ssi_private->clk)
	clk_prepare_enable(ssi_private->clk);

