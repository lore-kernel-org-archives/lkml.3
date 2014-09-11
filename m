Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaIKW5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:57:46 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39510 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaIKW5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:57:43 -0400
Date: Thu, 11 Sep 2014 15:57:37 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: timur@tabi.org, Li.Xiubo@freescale.com, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140911225737.GA13926@Alpha>
References: <27584da8e3ab291ab8dbcbb411579613f8384a59.1410413734.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27584da8e3ab291ab8dbcbb411579613f8384a59.1410413734.git.shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 01:38:29PM +0800, Shengjiu Wang wrote:
> Move the ipg clock enable and disable operation to startup and shutdown,
> that is only enable ipg clock when ssi is working. Keep clock is disabled
> when ssi is in idle.
> otherwise, _fsl_ssi_set_dai_fmt function need to be called in probe,
> so add ipg clock control for it.

It seems to be no objection so far against my last suggestion to
use regmap's mmio_clk() for named ipg clk only. So you may still
consider about that.

Anyway, I'd like to do thing in parallel. So I just simply tested
it on my side and its works fine, it may still need to be tested
by others though.

Nicolin
