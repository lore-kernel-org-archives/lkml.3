Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab3ALVvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 16:51:41 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:38496 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab3ALVvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 16:51:40 -0500
Message-ID: <50F1DAE7.4050508@gmail.com>
Date: Sat, 12 Jan 2013 22:51:35 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Dove: move CuBox led pinctrl to gpio-leds node
References: <1356646870-2903-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130112214257.GF13433@titan.lakedaemon.net>
In-Reply-To: <20130112214257.GF13433@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2013 10:42 PM, Jason Cooper wrote:
> On Thu, Dec 27, 2012 at 11:21:10PM +0100, Sebastian Hesselbarth wrote:
>> gpio-leds has support for pinctrl allocation, make use of it.
>>
>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>>  ...
>>   &pinctrl {
>> -	pinctrl-0 =<&pmx_gpio_12&pmx_gpio_18>;
>> +	pinctrl-0 =<&pmx_gpio_12>;
>>   	pinctrl-names = "default";
>>
>>   	pmx_gpio_12: pmx-gpio-12 {
>> --
>> 1.7.10.4
>
> I'm getting a merge conflict wit hthe above:
>
> &pinctrl {
> <<<<<<<  HEAD
>          pinctrl-0 =<&pmx_gpio_18>;
> =======
>          pinctrl-0 =<&pmx_gpio_12>;
>>>>>>>> ARM: Dove: move CuBox led pinctrl to gpio-leds node
>          pinctrl-names = "default";
>
>          pmx_gpio_18: pmx-gpio-18 {
>                  marvell,pins = "mpp18";
>                  marvell,function = "gpio";
>          };
> };
>
> Am I missing something?

Jason,

it depends on "ARM: Dove: move CuBox led pinctrl to gpio-leds node"
that you applied to mvebu/fixes two days ago.

You can postpone the patch another rc if that helps as it just moves
led pinctrl but still works when on pinctrl hog.

Sebastian
