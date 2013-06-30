Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3F3Q32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 12:29:28 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:61579 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab3F3Q3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 12:29:24 -0400
Date: Sun, 30 Jun 2013 19:28:27 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, broonie@kernel.org,
        grant.likely@linaro.org
Subject: Re: [PATCH 7/8] spi: spi-ep93xx: move the clock divider calcs into
 ep93xx_spi_chip_setup()
Message-ID: <20130630162827.GF786@mwesterb-mobl.lan>
References: <201306281145.29079.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306281145.29079.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 11:45:28AM -0700, H Hartley Sweeten wrote:
> The divider values stored in the per chip data are only used to set the
> registers in the hardware to generate the desired SPI clock. Since these
> are calculated per transfer based on the t->speed_hz there is no reason
> keep them in the per chip data.
> 
> Move the ep93xx_spi_calc_divisors() call into ep93xx_spi_chip_setup()
> and return the dividers thru pointers. Remove the divider values from
> the per chip data structure.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
