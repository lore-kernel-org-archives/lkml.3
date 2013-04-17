Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab3DQHAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 03:00:47 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6317 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab3DQHAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 03:00:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 16 Apr 2013 23:58:54 -0700
Message-ID: <516E47AA.2060402@nvidia.com>
Date: Wed, 17 Apr 2013 12:26:42 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "t-kristo@ti.com" <t-kristo@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] gpio: palmas: add dt support
References: <1366122705-3579-1-git-send-email-ldewangan@nvidia.com> <516D9C2B.302@wwwdotorg.org>
In-Reply-To: <516D9C2B.302@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 April 2013 12:14 AM, Stephen Warren wrote:
> On 04/16/2013 08:31 AM, Laxman Dewangan wrote:
>> Add of_device_id table for Palma GPIO to be enable the
>> driver from DT file.
>>
>> The driver can be registered from DT file as:
>> 	palmas: tps65913@58 {
>> 		:::::::::::
>> 		palmas_gpio: palmas_gpio {
>> 			compatible = "ti,palmas-gpio";
>> 			gpio-controller;
>> 			#gpio-cells = <2>;
>> 		};
>> 	};
> So I think this patch looks fine if everyone is agreed that all the
> Palmas sub-modules are represented as explicit child nodes in DT, and
> the probing of the child nodes is based on the top-level Palmas device
> being a bus, and enumerating its children in standard DT style, using
> compatible values. (I'm not sure how the child probing/instantiation
> will work for non-DT systems though).
>
> I'm not 100% sure if an agreement on the top-level structure of the
> Palmas DT bindings was reached though? Can the SlimLogic people confirm
> this? I assume Laxman must be OK with it since he's sending this patch?
>

I am fine with this dt approach.
Similar patch on palma-rtc was acked by Grant.

If Slimlogic/TI team can finalise the DT binding then it will be easy 
for me to push some more patches to have full support for palma driver 
on our Tegra platform.

