Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab3CHRMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:12:51 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:40570 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759805Ab3CHRMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:12:49 -0500
Message-ID: <513A1C0F.3070602@slimlogic.co.uk>
Date: Fri, 08 Mar 2013 17:12:47 +0000
From: Ian Lartey <ian@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: t-kristo@ti.com, broonie@opensource.wolfsonmicro.com,
        mturquette@linaro.org, linux-watchdog@vger.kernel.org,
        swarren@wwwdotorg.org, j-keerthy@ti.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        lgirdwood@gmail.com, grant.likely@secretlab.ca, wim@iguana.be,
        ldewangan@nvidia.com, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, rob@landley.net,
        cooloney@gmail.com, gg@slimlogic.co.uk, linux-leds@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH v8 0/12] Palmas Updates
References: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk> <513894E3.1070206@slimlogic.co.uk> <CACRpkdYHhh=ANiHvgxXiAQ_4LLiBBe0AfJ-60Wy6aEi7Cv0HOg@mail.gmail.com>
In-Reply-To: <CACRpkdYHhh=ANiHvgxXiAQ_4LLiBBe0AfJ-60Wy6aEi7Cv0HOg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/13 07:12, Linus Walleij wrote:
> On Thu, Mar 7, 2013 at 2:23 PM, Ian Lartey <ian@slimlogic.co.uk> wrote:
>
>> This patchset adds to the support for the Palmas iseries of PMIC chips.
>>
>> Some of the patches have previously been submitted individually.
>> The DT bindings doc has been added first due to comments that it was
>> missing.
>
> Can the patches to the individual subsystems be applied individually
> (like can we apply the two GPIO patches to the GPIO tree) or are
> the deps such that the whole shebang needs to go in at once and you're
> just harvesting ACKs to take it all into MFD or similar?

There are a few dependencies:

The GPIO and LEDS subsystem patches both depend on:
[PATCH v8 02/12] mfd: palmas: is_palmas_charger needed by multiple drivers

all the subsystems depend on:
[PATCH v8 01/12] mfd: DT bindings for the palmas family MFD
for their DT documentation.

so taking the whole shooting match in one go seems the safest.

>
> Yours,
> Linus Walleij


Regards,

Ian
