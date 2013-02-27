Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3B0W3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:29:14 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:44889 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab3B0W3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:29:13 -0500
Message-ID: <512E88B5.6050008@slimlogic.co.uk>
Date: Wed, 27 Feb 2013 22:29:09 +0000
From: Ian Lartey <ian@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        ldewangan@nvidia.com, j-keerthy@ti.com, gg@slimlogic.co.uk,
        wim@iguana.be, grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH 1/2] watchdog: add Palmas Watchdog support
References: <1361990168-882-1-git-send-email-ian@slimlogic.co.uk> <512E52BC.6070206@wwwdotorg.org> <512E69C5.5020607@slimlogic.co.uk> <512E6E5B.7010601@wwwdotorg.org>
In-Reply-To: <512E6E5B.7010601@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/13 20:36, Stephen Warren wrote:
> On 02/27/2013 01:17 PM, Ian Lartey wrote:
>> On 27/02/13 18:38, Stephen Warren wrote:
>>> On 02/27/2013 11:36 AM, Ian Lartey wrote:
>>>> From: Graeme Gregory <gg@slimlogic.co.uk>
>>>>
>>>> Add support for the Palmas watchdog timer which has a timeout
>>>> configurable
>>>> from 1s to 128s.
>>>
>>>> diff --git a/drivers/watchdog/palmas_wdt.c
>>>> b/drivers/watchdog/palmas_wdt.c
>>>
>>>> +static struct of_device_id of_palmas_match_tbl[] = {
>>>> +    { .compatible = "ti,palmas-wdt", },
>>>> +    { /* end */ }
>>>> +};
>>>
>>> Is there a DT binding document for that compatible value?
>>
>> The device tree for this compatible value is actually empty,
>> shall I remove it or is it OK to show it as empty in the
>> bindings document ?
>> There will be other palmas device bindings in this document.
>
> Well, you need a binding document that describes how to create this
> node. If it needs no properties other than compatible, it'll be a simple
> document!
>
> Did you review my comments on the other patches re: whether the
> sub-modules of this HW actually should be sub-nodes in DT or not? If
> not, then you don't need this node in DT, and hence there will be no
> compatible value for the node, and hence no need to write a binding
> document.

I've not reviewed your comments on the other patches, so I'll look at
those before responding properly.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

