Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3CDKWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:22:04 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:51702 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab3CDKWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:22:02 -0500
Message-ID: <5134758A.8010204@slimlogic.co.uk>
Date: Mon, 04 Mar 2013 10:20:58 +0000
From: Ian Lartey <ian@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH v2] gpio: palmas: add in GPIO support for palmas charger
References: <1362157598-11458-1-git-send-email-ian@slimlogic.co.uk> <5131ACC3.10803@nvidia.com> <20130302193500.783693E1095@localhost>
In-Reply-To: <20130302193500.783693E1095@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/13 19:35, Grant Likely wrote:
> On Sat, 2 Mar 2013 13:09:47 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
>> On Friday 01 March 2013 10:36 PM, Ian Lartey wrote:
>>> Palmas charger has 16 GPIOs
>>> add palmas_gpio_[read|write|update] api to take account
>>> second bank of GPIOs
>>>
>>> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
>>> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
>>> ---
>>
>> Looks good.
>> Acked-by: Laxman Dewangan<ldewangan@nvidia.com>
>>
>
> Applied for v3.10, thanks.
>
> g.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
Hello Grant,

For this [v2] patch I missed out that this patch depends on
"[PATCH v2] mfd: palmas: is_palmas_charger needed by multiple drivers."
I did have this noted in the first version of this patch - sorry.

kbuild rightly complained about the patch

Do you want to revert this patch until the
"mfd: palmas: is_palmas_charger needed by multiple drivers"
is also accepted ?




Ian
