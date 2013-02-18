Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3BRKYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:24:31 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61064 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3BRKY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:24:28 -0500
Date: Mon, 18 Feb 2013 10:24:21 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Emeric Vigier <emeric.vigier@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFT][PATCH 1/2] regulator: ab8500: Fix build error
Message-ID: <20130218102421.GA3538@gmail.com>
References: <1361156277.24231.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1361156277.24231.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

> This build error is introduced by commit 6a9fe8319
> "regulator: ab8500: Added get_optimum_mode on regulators with idle mode".
> 
>   CC      drivers/regulator/ab8500.o
> drivers/regulator/ab8500.c:500:23: error: 'ab8500_regulator_fixed_ops' undeclared here (not in a function)
> drivers/regulator/ab8500.c:510:3: error: unknown field 'update_val_enable' specified in initializer
> make[2]: *** [drivers/regulator/ab8500.o] Error 1
> make[1]: *** [drivers/regulator] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

The patches which caused the issues addressed by this patch-set have
since been rewritten. I have subsequently requested that Mark deletes
the AB8500 for-next branch. We're going to start again after this
merge window.

Thank you for your efforts though Axel, they are appreciated.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
