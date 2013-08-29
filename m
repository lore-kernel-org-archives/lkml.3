Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab3H2U3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:29:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49169 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3H2U3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:29:37 -0400
Message-ID: <521FAF2C.5070606@wwwdotorg.org>
Date: Thu, 29 Aug 2013 14:29:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fabian Vogt <vogtinator@myopera.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH V5] gpio: New driver for LSI ZEVIO SoCs
References: <1377541133-7427-1-git-send-email-fabian@ritter-vogt.de> <CACRpkdbnvnCiJ1apWA4gq03QH-vhmKae_3yYjYxEqGzYsWjaqg@mail.gmail.com> <op.w2lhuicjfdrgmf@fabians-laptop.fritz.box>
In-Reply-To: <op.w2lhuicjfdrgmf@fabians-laptop.fritz.box>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 02:28 PM, Fabian Vogt wrote:
>> On 08/26/2013 12:18 PM, Fabian Vogt wrote:
>>> This driver supports the GPIO controller found in LSI ZEVIO SoCs.
>>> It has been successfully tested on a TI nspire CX calculator.

>>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
>>> b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt

>>> +- #gpio-cells = <2>
>> This should describe what those cells are. For example perhaps:
>>
>> #gpio-cells. Must be 2. The first cell is the GPIO number. The second
>>  cell is used to specify optional parameters:
>>  - bit 0 specifies polarity (0 for normal, 1 for inverted)
>
> "Must be 2. The second cell is ... optional"?

I'm not sure what your question is, but perhaps this will answer it:

The 2nd cell isn't optional, but setting the various flags within the
cell is optional.
