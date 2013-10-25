Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3JYVMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 17:12:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42786 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab3JYVMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 17:12:47 -0400
Message-ID: <526ADECD.3050607@infradead.org>
Date: Fri, 25 Oct 2013 14:12:45 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 25 (of_gpio.h)
References: <1382713426-2680-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1382713426-2680-1-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/13 08:03, Thierry Reding wrote:
> Hi all,
> 
> I've uploaded today's linux-next tree to the master branch of the
> repository below:
> 
>         git://gitorious.org/thierryreding/linux-next.git
> 
> A next-20131025 tag is also provided for convenience.
> 
> One new trivial conflicts and a new build failure caused by an incorrect
> use of the genpool allocator.
> 
> Upon a request from Olof Johansson I've only included fixes for build
> breakage as a result of interactions between the various trees. But
> since I've fixed many of the other build failures already, I've pushed
> those to a separate tag (next-20131025-fixes). That builds fine on x86
> 32-bit and 64-bit allmodconfigs as well as ARM and x86 default
> configurations. Most of the PowerPC build errors have also been fixed.

on x86_64:

CONFIG_GPIOLIB is not set
CONFIG_OF is not set

In file included from drivers/leds/leds-lp55xx-common.c:24:0:
include/linux/of_gpio.h: In function 'of_get_named_gpio_flags':
include/linux/of_gpio.h:93:3: error: implicit declaration of function 'desc_to_gpio' [-Werror=implicit-function-declaration]

(not specific to leds-lp55xx-common.c)


-- 
~Randy
