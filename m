Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaKKNds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:33:48 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35090 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaKKNdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:33:46 -0500
Date: Tue, 11 Nov 2014 21:33:33 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v6 1/3] ARM: dts: pbab01: move i2c pins and frequency
 configuration into pfla02
Message-ID: <20141111133331.GA2704@dragon>
References: <1415106349-18846-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1415106349-18846-2-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415106349-18846-2-git-send-email-d.lavnikevich@sam-solutions.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 04:05:47PM +0300, Dmitry Lavnikevich wrote:
> Since pins and frequency are specific to module (pfla02), not base board
> (pbab02), it is better to be initialized in corresponding dts file.
> 
> This patch fixes i2c2, i2c3 pin configuration which caused messages:
> 
> imx6q-pinctrl 20e0000.iomuxc: no groups defined in /soc/aips-bus@02000000/iomuxc@020e0000/i2c2grp
> imx6q-pinctrl 20e0000.iomuxc: no groups defined in /soc/aips-bus@02000000/iomuxc@020e0000/i2c3grp
> imx6q-pinctrl 20e0000.iomuxc: unable to find group for node i2c2grp
> imx6q-pinctrl 20e0000.iomuxc: unable to find group for node i2c3grp
> 
> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>

Applied all 3, thanks.
