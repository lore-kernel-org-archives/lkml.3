Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965080AbaH0Ugp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:36:45 -0400
Received: from regular1.263xmail.com ([211.150.99.138]:33984 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaH0Ugm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:36:42 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: zyf@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <08d5e67b60108c564473209b002cf965>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53FE4153.3080601@rock-chips.com>
Date: Thu, 28 Aug 2014 04:36:35 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, zhaoyifeng <zyf@rock-chips.com>
Subject: Re: [PATCH v2 2/2] dt-bindings: document Rockchip thermal
References: <1409096503-7081-1-git-send-email-caesar.wang@rock-chips.com> <1409096503-7081-3-git-send-email-caesar.wang@rock-chips.com> <5911166.ElkaNhDZrP@wuerfel>
In-Reply-To: <5911166.ElkaNhDZrP@wuerfel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,


在 2014年08月28日 04:17, Arnd Bergmann 写道:
> On Wednesday 27 August 2014 07:41:43 Caesar Wang wrote:
>> +- clock-names : Shall be "tsadc_clk" for the transfer-clock, and "tsadc_pclk" for
>> +    the peripheral clock.
>>
> Why not just name them "clk" and "pclk"? The "tsadc" part seems highly redundant.
>
> Alternatively, how about "transfer" and "peripheral"?

It seems  nappropriate description.

But,I will fix  as the following:

-clock-names ： Shall be "tsadc" for the converter-clock, and "apb_pclk" for
               the peripheral clock.

Thanks!



>
> 	Arnd
>
>
>

-- 
Best regards,
Caesar


