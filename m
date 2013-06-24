Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3FXPjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:39:01 -0400
Received: from multi.imgtec.com ([194.200.65.239]:29721 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab3FXPjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:39:00 -0400
Message-ID: <51C86811.2010400@imgtec.com>
Date: Mon, 24 Jun 2013 16:38:57 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, "Rob Landley" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v3 1/4] pinctrl-tz1090: add TZ1090 pinctrl driver
References: <1371720391-21825-1-git-send-email-james.hogan@imgtec.com> <1371720391-21825-2-git-send-email-james.hogan@imgtec.com> <CACRpkdbMfWLf17Aty-a80_+gETTvLgO3wEWVFsnhuLypy61VBw@mail.gmail.com>
In-Reply-To: <CACRpkdbMfWLf17Aty-a80_+gETTvLgO3wEWVFsnhuLypy61VBw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_24_16_38_58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/13 16:04, Linus Walleij wrote:
> On Thu, Jun 20, 2013 at 11:26 AM, James Hogan <james.hogan@imgtec.com> wrote:
> 
>> Add a pin control driver for the main pins on the TZ1090 SoC. This
>> doesn't include the low-power pins as they're controlled separately via
>> the Powerdown Controller (PDC) registers.
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Rob Landley <rob@landley.net>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: linux-doc@vger.kernel.org
>> Cc: devicetree-discuss@lists.ozlabs.org
>> ---
>> Changes in v3:
>>  - separated from irq-imgpdc and removed arch/metag changes to allow
>>    these patches to go upstream separately via the pinctrl[/gpio] trees
>>    (particularly the pinctrl drivers depend on the new pinconf DT
>>    bindings).
>>  - some s/unsigned/unsigned int/.
>>  - some s/unsigned int/bool/ and use of BIT().
>>  - pinctrl-tz1090*: switch to generic pinconfig DT bindings and
>>    pinconf_generic_dump_config.
>>  - pinctrl-tz1090*: use tz1090, prefix for pins and function in DT
>>    bindings.
>>  - pinctrl-tz1090*: make internal functions static.
>>  - pinctrl-tz1090*: move initcall from postcore to arch.
> 
> Thanks James, patch applied.
> 
> Also thanks for helping out in getting the generic pinconf
> in place for some three different drivers for this merge window,
> this was very good for pinctrl at large.

Thanks Linus, and no problem!

Cheers
James

