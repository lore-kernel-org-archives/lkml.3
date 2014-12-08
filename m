Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaLHEMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 23:12:41 -0500
Received: from lucky1.263xmail.com ([211.157.147.131]:39118 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaLHEMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 23:12:39 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: romain.perier@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <587ddd76327141f6459c6654aa10e6f8>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5485252A.90308@rock-chips.com>
Date: Mon, 08 Dec 2014 12:12:26 +0800
From: Yunzhi Li <lyz@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Romain Perier <romain.perier@gmail.com>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>,
        Tao Huang <huangtao@rock-chips.com>,
        devicetree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, zyw@rock-chips.com,
        Rob Herring <robh+dt@kernel.org>, olof@lixom.net,
        Eddie Cai <cf@rock-chips.com>, ulrich.prinz@googlemail.com,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY.
References: <1417783941-2418-1-git-send-email-lyz@rock-chips.com>	<1417783941-2418-2-git-send-email-lyz@rock-chips.com> <CABgxDoLe2RxCjD53uvTgYZ=tNOKHLeGoZE5Aa5XvaUYvNX=HYw@mail.gmail.com>
In-Reply-To: <CABgxDoLe2RxCjD53uvTgYZ=tNOKHLeGoZE5Aa5XvaUYvNX=HYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Romain :

On 2014/12/5 21:38, Romain Perier wrote:
> Hi,
>
> Some quick comments
>
> 2014-12-05 13:52 GMT+01:00 Yunzhi Li <lyz@rock-chips.com>:
>> [...]
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index ccad880..e3a5857 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -239,6 +239,13 @@ config PHY_QCOM_IPQ806X_SATA
>>          depends on OF
>>          select GENERIC_PHY
>>
>> +config PHY_ROCKCHIP_RK3288_USB2
>> +       tristate "Rockchip USB2 RK3288 PHY Driver"
>> +       depends on ARCH_ROCKCHIP && OF
>> +       select GENERIC_PHY
>> +       help
>> +         Enable this to support the Rockchip USB 2.0 PHY.
>> +
>
> The C module is named phy-rockchip-usb.c, why did you call the config
> entry PHY_ROCKCHIP_RK3288_USB2 ? why RK3288 ? this driver might be
> ported to old SoCs later.
> I think that PHY_ROCKCHIP_USB would be enough.
Right, this driver will be ported to old SoCs like RK3188 or RK3066, 
this will be renamed to PHY_ROCKCHIP_USB in the next version.


