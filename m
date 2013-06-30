Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3F3Q21 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 12:28:27 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:41722 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3F3Q2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 12:28:24 -0400
Date: Sun, 30 Jun 2013 19:27:29 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, broonie@kernel.org,
        grant.likely@linaro.org
Subject: Re: [PATCH 6/8] spi: spi-ep93xx: don't bother calculating the
 divisors in ep93xx_spi_setup()
Message-ID: <20130630162729.GE786@mwesterb-mobl.lan>
References: <201306281145.02815.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306281145.02815.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 11:45:02AM -0700, H Hartley Sweeten wrote:
> The divisors needed to generate the SPI clock are calculated per
> transfer based on the t->speed_hz. There is no reason to calculate
> them in ep93xx_spi_setup().
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
