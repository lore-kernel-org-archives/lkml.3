Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430Ab3DBLp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:45:56 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64808 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760173Ab3DBLpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:45:55 -0400
Date: Tue, 2 Apr 2013 12:45:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@ingics.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: ab8500: Staticize
 ab8500_ext_regulator_[init|exit] if !CONFIG_REGULATOR_AB8500_EXT
Message-ID: <20130402114549.GA5580@gmail.com>
References: <1364862038.15806.1.camel@phoenix>
 <20130402112740.GI23065@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130402112740.GI23065@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Apr 2013, Mark Brown wrote:

> On Tue, Apr 02, 2013 at 08:20:38AM +0800, Axel Lin wrote:
> > Fix below build errors:
> > 
> >   LD      arch/arm/mach-ux500/built-in.o
> > arch/arm/mach-ux500/board-mop500-regulators.o: In function `ab8500_ext_regulator_init':
> 
> Lee?

Better if you can send me the whole patch.

We're not paying by the Byte anymore. :)

I'll look into it.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
