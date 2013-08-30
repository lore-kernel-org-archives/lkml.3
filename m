Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3H3Ffv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 01:35:51 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50580 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3H3Ffs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 01:35:48 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522020A7.9060405@roeck-us.net>
Date: Thu, 29 Aug 2013 21:33:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        George Cherian <george.cherian@ti.com>, balbi@ti.com,
        myungjoo.ham@samsung.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, rob@landley.net, ian.campbell@citrix.com,
        mark.rutland@arm.com, pawel.moll@arm.co
Subject: Re: [PATCH 1/2] extcon: extcon-dra7xx: Add extcon driver for USB
 ID detection
References: <1376648029-30659-1-git-send-email-george.cherian@ti.com> <1376648029-30659-2-git-send-email-george.cherian@ti.com> <52127284.6030506@wwwdotorg.org> <521312CC.8060003@ti.com> <52139F0F.6090507@wwwdotorg.org> <52199663.8070201@roeck-us.net> <521FE549.3080605@samsung.com>
In-Reply-To: <521FE549.3080605@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 05:20 PM, Chanwoo Choi wrote:
> Hi Guenter,
>
>> I am currently working on adding device tree support to the extcon-gpio driver.
>>
>> Wonder if it would make sense to just use that driver. As far as I can see
>> the only missing part is support for multiple cables and cable naming through
>> device tree properties.
>>
>> Any thoughts ? The patches are not yet clean enough to submit upstream,
>> but I could send them as RFC if there is interest.
>>
>
> I'm considering ways to use and update extcon-gpio driver.
> I have interest concerning your approach.
> After completing your work, send them as RFC as you mentioned.
>

It does what we need it to do, so I sent it out a minute ago.
I added possible bindings for multi-cable support as additional RFC.

Guenter

