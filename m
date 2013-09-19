Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3ISINx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:13:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46330 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3ISINu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:13:50 -0400
Message-ID: <523AB235.1000808@ti.com>
Date: Thu, 19 Sep 2013 13:43:41 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: PCF857x and 16-bit GPIO expanders
References: <20130917190732.GD15645@radagast> <CACRpkdYn8yaTyFJMaC3vK4kGrQsaZpAX=pyn5y33ers7QhQ_pg@mail.gmail.com> <2356541.62QktiIBr5@avalon> <20130918173636.GT21559@radagast>
In-Reply-To: <20130918173636.GT21559@radagast>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/2013 11:06 PM, Felipe Balbi wrote:
> Hi,
>
> On Wed, Sep 18, 2013 at 07:18:04PM +0200, Laurent Pinchart wrote:
>> On Wednesday 18 September 2013 13:16:27 Linus Walleij wrote:
>>> On Tue, Sep 17, 2013 at 9:07 PM, Felipe Balbi <balbi@ti.com> wrote:
>>>> has anyone ever successfully using gpio-pcf857x.c driver with 16-bit
>>>> gpio expanders ? We're having some issues here where toggling the last
>>>> gpio pin (gpio 15) on a PCF8575 device causes platform to hang and I
>>>> can't come up with any explanation of why would it hang...
>>> Bouncing the question to George, Laurent and Kuninori...
>> I've got a board with a PCF8575 chip, but it uses I/Os 8 to 14 only as far as
>> I know.
>>
>> I can try toggling I/O 15, but that will need to wait until next week as I'm
>> currently travelling without access to the hardware.
> alright, that'd help me a lot :-) Just want to make sure if we're having
> a board issue, or PCF8575 is a bit screwy ;-)
Is it on dra7x-evm if so which pcf device (i2c address)?
The pins i were interested were only 1 and 2 I never tried pin 15.

Just tried toggling through sysfs and it works for me.
>
> Thanks
>


-- 
-George

