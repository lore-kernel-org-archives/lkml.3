Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaKFNWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:22:04 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:48325 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaKFNWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:22:00 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: jack.dai@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <459cf3e43b23fcab5c78f03c3c7d1a6a>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <545B75E8.2000903@rock-chips.com>
Date: Thu, 06 Nov 2014 21:21:44 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kever Yang <kever.yang@rock-chips.com>, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        fzf@rock-chips.com, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, cf@rock-chips.com,
        Jack Dai <jack.dai@rock-chips.com>
Subject: Re: [PATCH v8 1/3] power-domain: rockchip: add power domain drivers
References: <1415254961-5746-1-git-send-email-caesar.wang@rock-chips.com> <1415254961-5746-2-git-send-email-caesar.wang@rock-chips.com> <545B3A18.9030405@rock-chips.com>
In-Reply-To: <545B3A18.9030405@rock-chips.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2014年11月06日 17:06, Kever Yang 写道:
>
> On 11/06/2014 02:22 PM, Caesar Wang wrote:
>> In order to meet high performance and low power requirements, a power
>> management unit is designed or saving power when RK3288 in low power 
>> mode.
>> The RK3288 PMU is dedicated for managing the power ot the whole chip.
>>
>> Signed-off-by: Jack Dai<jack.dai@rock-chips.com>
>> Signed-off-by: jinkun.hong<jinkun.hong@rock-chips.com>
>> Signed-off-by: Caesar Wang<caesar.wang@rock-chips.com>
>>
>> ---
>>
>> Changes in v8:
>>      - This reconciles the v2 and v7 code so that we power domain have
>>      lists of clocks they toggle on and off during power transitions and
>>      independently from power domains clocks we attach clocks to devices
>>      comprising power domain and prepare them so they are turned on 
>> and off
>>      by runtime PM.
> There are more changes like the new rockchip_pm_add_one_domain.

OK.

>>
>> Changes in v7:
>>      - Delete unused variables
>
>
>
>

-- 
Best regards,
Caesar


