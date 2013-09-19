Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3ISLtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:49:23 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:57194 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3ISLtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:49:22 -0400
Date: Thu, 19 Sep 2013 12:49:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Marc Reilly <marc@cpdesign.com.au>, u.kleine-koenig@pengutronix.de,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/3] mfd: mc13xxx: Move SPI erratum workaround into SPI
 I/O function
Message-ID: <20130919114910.GE22389@lee--X1>
References: <1379527587-14567-1-git-send-email-broonie@kernel.org>
 <1379527587-14567-2-git-send-email-broonie@kernel.org>
 <20130919091318.GA22389@lee--X1>
 <20130919095628.GH21013@sirena.org.uk>
 <20130919100434.GB22389@lee--X1>
 <20130919114107.GL21013@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130919114107.GL21013@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Either way, it needs changing.
> 
> Let's see if someone actually tests the code first though.

I've taken the liberty of bulding it, but I don't have the h/w to
actually run the code.

I get:
  drivers/mfd/mc13xxx-spi.c: In function ‘mc13xxx_spi_write’:
  drivers/mfd/mc13xxx-spi.c:97:14: warning: initialisation discards ‘const’ qualifier from pointer target type [enabled by default]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
