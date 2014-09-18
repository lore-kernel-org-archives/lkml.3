Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbaIRTec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:34:32 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:46672 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaIRTeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:34:31 -0400
Message-ID: <541B33C3.2080102@gmail.com>
Date: Thu, 18 Sep 2014 21:34:27 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: samsung: Remove remaining check for CONFIG_S5P_GPIO_DRVSTR
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>	 <53C67783.4090407@samsung.com> <1409825317.5546.94.camel@x220>	 <201409041803.46098.arnd@arndb.de> <1411030649.2017.7.camel@x220>
In-Reply-To: <1411030649.2017.7.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On 18.09.2014 10:57, Paul Bolle wrote:
> On Thu, 2014-09-04 at 18:03 +0200, Arnd Bergmann wrote:
>> On Thursday 04 September 2014, Paul Bolle wrote: 
>>> That check for CONFIG_S5P_GPIO_DRVSTR is still present in v3.17-rc3 and
>>> next-20140903. Should I submit the trivial patch to remove it (and the
>>> dead code it hides)?
>>
>> Yes, I think this one is an obvious candidate for removal.
> 
> Still there in v3.17-rc5 and next-20140918. So I submit yet another
> trivial cleanup.
> 
> Done on top of next-20140918. Only tested by grepping the tree. Please
> note that, obviously, nothing uses s5p_gpio_get_drvstr() or
> s5p_gpio_set_drvstr().
> 
> 
> Paul Bolle
> -------->8--------
> From: Paul Bolle <pebolle@tiscali.nl>
> 
> Commit d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
> removed the Kconfig symbol S5P_GPIO_DRVSTR. It didn't remove one check
> for the related macro. Remove that check and the dead code it hides.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks for the patch.

Reviewed-by: Tomasz Figa <tomasz.figa@gmail.com>

Best regards,
Tomasz
