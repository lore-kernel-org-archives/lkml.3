Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaEVQJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:09:05 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:58708 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaEVQJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:09:04 -0400
Date: Thu, 22 May 2014 17:08:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: axp20x: Remove unnecessary const qualifier from
 axp20x_supplies[]
Message-ID: <20140522160856.GJ19747@lee--X1>
References: <1400750311-15323-1-git-send-email-lee.jones@linaro.org>
 <1400750311-15323-2-git-send-email-lee.jones@linaro.org>
 <1400774373.21099.1.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400774373.21099.1.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > drivers/mfd/axp20x.c:159:3:
> >   warning: initialization discards ‘const’ qualifier from pointer target type
> >    .parent_supplies = axp20x_supplies,
> []
> > diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
> []
> > @@ -140,7 +140,7 @@ static const struct regmap_irq_chip axp20x_regmap_irq_chip = {
> >  	.init_ack_masked	= true,
> >  };
> >  
> > -static const char * const axp20x_supplies[] = {
> > +static const char * axp20x_supplies[] = {
> >  	"acin",
> >  	"vin2",
> >  	"vin3",
> 
> Perhaps you're doing this the wrong way round.
> Maybe this definition should change.
> 
> include/linux/mfd/core.h:       const char              **parent_supplies;

Are you asking me, or telling me? :)

To be frank, I've never known what the double const means.  Care to
enlighten?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
