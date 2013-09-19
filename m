Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3ISKFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:05:04 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:48170 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3ISKFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:05:02 -0400
Date: Thu, 19 Sep 2013 11:04:34 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Marc Reilly <marc@cpdesign.com.au>, u.kleine-koenig@pengutronix.de,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/3] mfd: mc13xxx: Move SPI erratum workaround into SPI
 I/O function
Message-ID: <20130919100434.GB22389@lee--X1>
References: <1379527587-14567-1-git-send-email-broonie@kernel.org>
 <1379527587-14567-2-git-send-email-broonie@kernel.org>
 <20130919091318.GA22389@lee--X1>
 <20130919095628.GH21013@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130919095628.GH21013@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please delete irrelevant context from mails, it makes it easier to find
> the new content that's beenn added.

I did, off the bottom.

I only left 22 lines at the top. You're just being pernickety.

> > On Wed, 18 Sep 2013, Mark Brown wrote:
> 
> > > @@ -94,10 +94,15 @@ static int mc13xxx_spi_write(void *context, const void *data, size_t count)
> > >  {
> > >  	struct device *dev = context;
> > >  	struct spi_device *spi = to_spi_device(dev);
> > > +	char *reg = data;
> 
> > I think this requires a cast.
> 
> No, you should never need a cast to or from void in C - it probably does
> want to be a const char though.

Either way, it needs changing.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
