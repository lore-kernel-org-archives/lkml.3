Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3GYIIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:08:35 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:58692 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab3GYIIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:08:07 -0400
Date: Thu, 25 Jul 2013 09:08:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/2] mfd: Add Dialog DA9063 core driver.
Message-ID: <20130725080800.GC3403@laptop>
References: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
 <1374683683-13370-2-git-send-email-p.zabel@pengutronix.de>
 <20130725080443.GB3403@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130725080443.GB3403@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/mfd/Kconfig                  |   12 +
> >  drivers/mfd/Makefile                 |    3 +
> >  drivers/mfd/da9063-core.c            |  177 ++++++
> >  drivers/mfd/da9063-i2c.c             |  197 ++++++
> >  drivers/mfd/da9063-irq.c             |  193 ++++++
> >  include/linux/mfd/da9063/core.h      |  110 ++++
> >  include/linux/mfd/da9063/pdata.h     |  114 ++++
> >  include/linux/mfd/da9063/registers.h | 1090 ++++++++++++++++++++++++++++++++++
> >  8 files changed, 1896 insertions(+)
> 
> Whoah!! Who's going to want to review a 2k line patch?
> 
> Any chance you can split this stuff up into more 'bite sized' patches?

You also missed Sam off the addressees list, which is not a good idea.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
