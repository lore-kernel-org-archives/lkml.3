Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3C1GIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:08:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3249 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3C1GIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:08:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 27 Mar 2013 23:07:41 -0700
Message-ID: <5153DD9F.2090101@nvidia.com>
Date: Thu, 28 Mar 2013 11:35:19 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] gpio: palmas: add dt support
References: <1363876214-25933-1-git-send-email-ldewangan@nvidia.com> <CACRpkdY_9pEkNfp7L82nGjsjFOi-VXwPHo7_3XwjCz8XcN8osg@mail.gmail.com> <51531706.4040608@wwwdotorg.org>
In-Reply-To: <51531706.4040608@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 March 2013 09:27 PM, Stephen Warren wrote:
> On 03/27/2013 07:00 AM, Linus Walleij wrote:
>> On Thu, Mar 21, 2013 at 3:30 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
>>
>>>   #ifdef CONFIG_OF_GPIO
>>> -       palmas_gpio->gpio_chip.of_node = palmas->dev->of_node;
>>> +       palmas_gpio->gpio_chip.of_node = pdev->dev.of_node;
>>>   #endif
>> OK I think that #ifdef is necessary...
> Laxman,
>
> Don't we need to resolve and agree on the final DT bindings before we
> can start making changes like this? It's not clear yet whether everyone
> is on the same page re: how the MFD sub-devices are modelled in DT -
> whether each sub-component really is a standalone device, or whether the
> MFD itself instantiates all its children based on internal static tables
> rather than DT.
Yes, we need to agree on DT. I sent the patch based on the patches came 
from TI/Slimlogic and other discussion about DT patches.
Recently, you commented on  DT for palmas, it need to  be completely IP 
based or hw based. Mix will not work.
If it is IP based then almost all palmas-* file need to be rewrite, no 
one is written as IP based. All are using palma structures, palma 
header, palma macro etc
which should not be there.

>
> Given that, I'm not sure why the Slimlogic people aren't CC'd on this
> patch:-(

I have not added then on my original patch as 
./script/get_maintainers.pl did not give me name.
However, you added immediately them (TI and slimlogic) on this patch 
itself. I have not got any feedback from them yet.



I

