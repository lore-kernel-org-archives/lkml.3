Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3FONOh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:14:37 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48549 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3FONOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:14:36 -0400
Date: Sat, 15 Jun 2013 15:14:32 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 0/6] Add support for Allwinner A10s SoCs
Message-ID: <20130615131432.GW16699@lukather>
References: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sun, Jun 09, 2013 at 06:36:01PM +0200, Maxime Ripard wrote:
> Hi everyone,
> 
> This patch serie reworks a bit the pinctrl driver and adds the necessary
> bits needed to support the Allwinner A10s SoC.
> 
> This SoC is a bit in between the A10 and A13. Notable differences with
> the A13 is the addition of an HDMI controller and of the EMAC.
> 
> For the time being (ie until we find a proper datasheet for this SoCs),
> the clock definition is taken from the A10 one.
> 
> This patches depends on the "Add external interrupt support for Allwinner SoCs"
> patch serie.

Do you have any comments on the two patches on the pinctrl driver?

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
