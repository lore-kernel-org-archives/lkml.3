Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3F3Qb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 12:31:26 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:52844 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3F3QbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 12:31:24 -0400
Date: Sun, 30 Jun 2013 19:30:27 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, broonie@kernel.org,
        grant.likely@linaro.org
Subject: Re: [PATCH 8/8] spi: spi-ep93xx: convert to the queued driver
 infrastructure
Message-ID: <20130630163027.GG786@mwesterb-mobl.lan>
References: <201306281145.56990.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306281145.56990.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 11:45:56AM -0700, H Hartley Sweeten wrote:
> The SPI core provides infrastructure for standard message queueing. Use
> that instead of handling it in the driver.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/spi/spi-ep93xx.c | 164 ++++++-----------------------------------------
>  1 file changed, 19 insertions(+), 145 deletions(-)

Nice reduction of code lines!

Thanks for doing this.

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
