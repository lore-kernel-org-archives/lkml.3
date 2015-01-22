Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbbAVJh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:37:57 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:46657 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbbAVJhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:37:53 -0500
Message-ID: <54C0C4EA.5020404@ultimaker.com>
Date: Thu, 22 Jan 2015 10:37:46 +0100
From: Olliver Schinagl <o.schinagl@ultimaker.com>
Organization: Ultimaker B.V.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Rojhalat Ibrahim <imr@rtschenk.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Olliver Schinagl <oliver@schinagl.nl>,
        Robin Gong <b38343@freescale.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Grant Likely <grant.likely@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Alexander Shiyan <shc_work@mail.ru>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH v2 4/4] leds: no longer use unnamed gpios
References: <1421876028-22799-1-git-send-email-o.schinagl@ultimaker.com> <1421876028-22799-5-git-send-email-o.schinagl@ultimaker.com> <2355733.gZvsF3iKWH@pcimr>
In-Reply-To: <2355733.gZvsF3iKWH@pcimr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Rojhalat,

On 22-01-15 10:32, Rojhalat Ibrahim wrote:
> On Wednesday 21 January 2015 22:33:48 Olliver Schinagl wrote:
>> From: Olliver Schinagl <oliver@schinagl.nl>
>>
>> The gpio document says we should not use unnamed bindings for gpios.
>> This patch uses the 'led-' prefix to the gpios and updates code and
>> documents. Because the devm_get_gpiod_from_child() falls back to using
>> old-style unnamed gpios, we can update the code first, and update
>> dts files as time allows.
>>
>> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
> Where does devm_get_gpiod_from_child() fall back "to using old-style
> unnamed gpios"?
Your absolutly right, I accidentally forgot a patch that was supposed to 
get squashed into this patchset. The idea is to do the same as in 
gpio-keys-polled.c. I'll make sure it sits in v3 of the set! My appologies!

Olliver
>
> After applying this patch the leds defined in my devicetree do not
> work anymore.
>
>     Rojhalat
>
>
>

-- 
Met vriendelijke groeten, Kind regards, 与亲切的问候

Olliver Schinagl
Research & Development
Ultimaker B.V.
http://www.ultimaker.com

