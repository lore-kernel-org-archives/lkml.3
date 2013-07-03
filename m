Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab3GCSHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:07:55 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:43307 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab3GCSHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:07:54 -0400
Date: Wed, 3 Jul 2013 21:06:57 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, broonie@kernel.org,
        grant.likely@linaro.org, hsweeten@visionengravers.com
Subject: Re: [PATCH v2 07/11] spi: spi-ep93xx: remove 'dss' from per chip
 private data
Message-ID: <20130703180657.GF26568@mwesterb-mobl.lan>
References: <201307021009.30230.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201307021009.30230.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 10:09:29AM -0700, H Hartley Sweeten wrote:
> This value is only needed to set the bits per word for each transfer
> of a message. There is no reason to set the value in ep93xx_spi_enable()
> because ep93xx_spi_process_transfer() sets it again for each transfer.
> 
> Just pass the t->bits_per_word directly to ep93xx_spi_chip_setup() in
> ep93xx_spi_process_transfer() and remove 'dss' from the per chip private
> data.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
