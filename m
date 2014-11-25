Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaKYAqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 19:46:40 -0500
Received: from regular1.263xmail.com ([211.150.99.137]:36554 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaKYAqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 19:46:38 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: fzf@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <957a2fdae83b880c0b40ed874edc4b51>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5473D163.9070708@rock-chips.com>
Date: Tue, 25 Nov 2014 08:46:27 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Eduardo Valentin <edubezval@gmail.com>
CC: rui.zhang@intel.com, zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dmitry.torokhov@gmail.com, huangtao@rock-chips.com,
        fzf@rock-chips.com
Subject: Re: [PATCH v19 0/5] Rockchip soc thermal driver
References: <1416805142-27304-1-git-send-email-caesar.wang@rock-chips.com> <20141124201807.GA20404@developer> <1771961.FfLxNDNiti@diego>
In-Reply-To: <1771961.FfLxNDNiti@diego>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

在 2014年11月25日 07:39, Heiko Stübner 写道:
> Hi Caesar,
>
> Am Montag, 24. November 2014, 16:18:12 schrieb Eduardo Valentin:
>> Hello Caesar,
>>
>> On Mon, Nov 24, 2014 at 12:58:57PM +0800, Caesar Wang wrote:
>>> This series patchs tested on rk3288 SDK board and pinky-v1,v2 board.
>>> I believe the driver can be used on the rk3288-evb board.
>>>
>>> Add this driver, The system will shutdown when
>>> the thermal temperture over 100C.If for some reason we are unable to
>>> shut it down in orderly fashion (kernel is stuck holding a lock or
>>> similar)
>>> then hardware will reset it.
>>>
>>> The patchs 1/5,2/5 can applay Eduardo's Branch
>>> git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.g
>>> it [branch "next-kernel"]
>>>
>>> 	remote = origin
>>> 	merge = refs/heads/next
>> I applied your patches 1 and 2 in my -linus branch, and luckily will be
>> accepted for 3.19.
> and I've taken patches 3, 4 and 5 into my dts branch for 3.19 .
>
> I've adapted the commit messages in some places and removed the
> 	/* sensor		ID */
> comments from the rk3288-thermal.dtsi.
>
OK,
Thanks!

> Heiko
>
>
>

-- 
Best regards,
Caesar


