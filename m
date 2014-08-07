Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbaHGNzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:55:32 -0400
Received: from regular1.263xmail.com ([211.150.99.137]:49167 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435AbaHGNzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:55:31 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: linux-doc@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <d41fea89ba793e0dc889431a31c8b9ea>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53E3854C.9070005@rock-chips.com>
Date: Thu, 07 Aug 2014 21:55:24 +0800
From: caesar <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: heiko@sntech.de, b.galvani@gmail.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, rdunlap@infradead.org,
        galak@codeaurora.org, cf@rock-chips.com, huangtao@rock-chips.com,
        xjq@rock-chips.com, addy.ke@rock-chips.com, cjf@rock-chips.com,
        hj@rock-chips.com, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 2/2] pwm: rockchip: Added to support for RK3288 SoC
References: <1406197295-10604-1-git-send-email-caesar.wang@rock-chips.com> <1406197295-10604-3-git-send-email-caesar.wang@rock-chips.com> <20140807061842.GB17340@ulmo> <53E3795E.4080607@rock-chips.com> <20140807131443.GA1540@ulmo.nvidia.com>
In-Reply-To: <20140807131443.GA1540@ulmo.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry,

在 2014年08月07日 21:14, Thierry Reding 写道:
> On Thu, Aug 07, 2014 at 09:04:30PM +0800, caesar wrote:
> [...]
>> As you say, I will rewrite the about if it's really need  do so it.
>> For example:
>>
>> static const struct rockchip_pwm_data pwm_data_v1 = {
>>      .regs = {
>>                  .duty = 0x04,
>>                  .period = 0x08,
>>                  .cntr = 0x00,
>>                  .ctrl = 0x0c,
>>      },
>>      .prescaler = 2,
>>      .set_enable = rockchip_pwm_set_enable_v1,
>> };
>>
>> static const struct rockchip_pwm_data pwm_data_v2 = {
>>      .regs = {
>>                  .duty = 0x08,
>>                  .period = 0x04,
>>                  .cntr = 0x00,
>>                  .ctrl = 0x0c,
>>      },
>>      .prescaler = 1,
>>      .set_enable = rockchip_pwm_set_enable_v2,
>> };
>>
>> static const struct rockchip_pwm_data pwm_data_vop = {
>>      .regs = {
>>                  .duty = 0x08,
>>                  .period = 0x04,
>>                  .cntr = 0x0c,
>>                  .ctrl = 0x00,
>>      },
>>      .prescaler = 1,
>>      .set_enable = rockchip_pwm_set_enable_v2,
>> };
>>
>> Is that right?
> Yes.
>
>>>> +	.set_enable = rockchip_pwm_set_enable_v2,
>>>> +};
>>> No need for the double indirection.
>> Sorry, I think is need if you mean a double indirection for ".set_enable".
> The "double indirection" was regarding the symbolic names for registers,
> not the .set_enable(). Sorry.
OK,I will fix the about in patch v5 tomorrow if no other problems,Thanks!
> Thierry


