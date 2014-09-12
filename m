Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaILSdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:33:32 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:64842 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaILSdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:33:31 -0400
Date: Fri, 12 Sep 2014 11:33:24 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>, timur@tabi.org
Cc: Li.Xiubo@freescale.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, mpa@pengutronix.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140912183324.GA2738@Alpha>
References: <894383e00876763f22988fc5f3f9f232f939f923.1410517971.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <894383e00876763f22988fc5f3f9f232f939f923.1410517971.git.shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 06:35:15PM +0800, Shengjiu Wang wrote:
> Check if ipg clock is in clock-names property, then we can move the
> ipg clock enable and disable operation to startup and shutdown, that
> is only enable ipg clock when ssi is working and keep clock is disabled
> when ssi is in idle.
> But when the checking is failed, remain the clock control as before.
> 
> Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>

The patch looks fine to me. I tested the has_ipg_clk_name == true
case, and it works fine. As long as there's no further objection,
I can give an Acked-by. (I think Timur and Markus may like to have
a test as well.)

Thank you
Nicolin
