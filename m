Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaILCoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 22:44:05 -0400
Received: from muin.pair.com ([209.68.1.55]:62879 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbaILCoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 22:44:03 -0400
Message-ID: <54125DEF.4090101@tabi.org>
Date: Thu, 11 Sep 2014 21:43:59 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Shengjiu Wang <shengjiu.wang@freescale.com>, nicoleotsuka@gmail.com,
        Li.Xiubo@freescale.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de
CC: alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ASoC: fsl_ssi: refine ipg clock usage in this module
References: <27584da8e3ab291ab8dbcbb411579613f8384a59.1410413734.git.shengjiu.wang@freescale.com>
In-Reply-To: <27584da8e3ab291ab8dbcbb411579613f8384a59.1410413734.git.shengjiu.wang@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shengjiu Wang wrote:
> +	ret = clk_prepare_enable(ssi_private->clk);
> +	if (ret)
> +		return ret;

Will this work on PowerPC, where ssi_private->clk is always NULL?
