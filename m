Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160Ab3ARIBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 03:01:36 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:17268 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898Ab3ARIBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 03:01:34 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 18 Jan 2013 16:02:13 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the gpio-lw tree
Message-ID: <20130118080211.GA8706@S2101-09.ap.freescale.net>
References: <20130118140346.3f9b182aa7daa175b4f136bf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130118140346.3f9b182aa7daa175b4f136bf@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 02:03:46PM +1100, Stephen Rothwell wrote:
> Hi Linus,
> 
> After merging the gpio-lw tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
My bad, sorry for that.  I just sent a v2 in reply to this message
for fixing the error.  I spent some time trying to install a ppc64
toolchain for testing, but unfortunately with on luck.  So Stephen,
I have to rely on linux-next to give it a test again.  Thanks.

Shawn

> drivers/gpio/devres.c:51:5: error: redefinition of 'devm_gpio_request'
> include/linux/gpio.h:97:19: note: previous definition of 'devm_gpio_request' was here
> drivers/gpio/devres.c:80:5: error: redefinition of 'devm_gpio_request_one'
> include/linux/gpio.h:109:19: note: previous definition of 'devm_gpio_request_one' was here
> drivers/gpio/devres.c:113:6: error: redefinition of 'devm_gpio_free'
> include/linux/gpio.h:128:20: note: previous definition of 'devm_gpio_free' was here
> 
> Presumably caused by commit d39cd0301255 ("gpio: devm_gpio_* support
> should not depend on GPIOLIB").

