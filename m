Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaKZXPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:15:03 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:42011 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaKZXO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:14:57 -0500
Date: Thu, 27 Nov 2014 00:12:25 +0100
From: Beniamino Galvani <b.galvani@gmail.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        broonie <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>, linux-spi@vger.kernel.org
Subject: Re: randconfig build error with next-20141126, in
 drivers/spi/spi-meson-spifc.c
Message-ID: <20141126231225.GA17600@gmail.com>
References: <CA+r1Zhh3Fhcvx9nSDxPnrC-gzR0Z50O7nwzvkhhX6QAS2qmasQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+r1Zhh3Fhcvx9nSDxPnrC-gzR0Z50O7nwzvkhhX6QAS2qmasQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 10:53:28AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/built-in.o: In function `meson_spifc_probe':
> spi-meson-spifc.c:(.text+0x14b4a8): undefined reference to
> `devm_regmap_init_mmio_clk'
> make: *** [vmlinux] Error 1

Hi,

I've just submitted a fix for the missing Kconfig dependency.

Thanks,
Beniamino
