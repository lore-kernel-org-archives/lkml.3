Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3F3Q1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 12:27:49 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:55587 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3F3Q1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 12:27:46 -0400
Date: Sun, 30 Jun 2013 19:26:50 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, broonie@kernel.org,
        grant.likely@linaro.org
Subject: Re: [PATCH 3/8] spi: spi-ep93xx: always handle transfer specific
 settings
Message-ID: <20130630162650.GD786@mwesterb-mobl.lan>
References: <201306281143.35130.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306281143.35130.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 11:43:34AM -0700, H Hartley Sweeten wrote:
> __spi_async(), which starts every SPI message transfer, initializes
> the bits_per_word and max speed for every transfer in the message.
> Since the conditional test in ep93xx_spi_process_transfer() will
> always succeed just remove it and always call ep93xx_spi_chip_setup()
> to configure the hardware for each transfer in the message.
> 
> Remove the redundant ep93xx_spi_chp_setup() in ep93xx_spi_process_transfer()
> which just initializes the hardware to the "default" based on the SPI
> device.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
