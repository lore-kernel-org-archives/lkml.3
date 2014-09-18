Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbaIRCdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:33:16 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:50465 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377AbaIRCdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:33:14 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: cjf@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <bf4e8b6b9d0c7ad7a14755ab47d6661c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <541A4461.4080101@rock-chips.com>
Date: Thu, 18 Sep 2014 10:33:05 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Doug Anderson <dianders@chromium.org>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Zhang Rui <rui.zhang@intel.com>, edubezval@gmail.com,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Tao Huang <huangtao@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Dmitry Torokhov <dtor@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        zyf <zyf@rock-chips.com>,
        =?UTF-8?B?6ZmI5riQ6aOe?= <cjf@rock-chips.com>
Subject: Re: [PATCH v5 2/4] dt-bindings: document Rockchip thermal
References: <1410926353-15674-1-git-send-email-caesar.wang@rock-chips.com> <1410926353-15674-3-git-send-email-caesar.wang@rock-chips.com> <CAD=FV=Vq4zSBv-=OxHD4sGbAgLh_ebe29PR6RU_sQe4XspsPsw@mail.gmail.com> <20140917201347.GD25297@core.coreip.homeip.net>
In-Reply-To: <20140917201347.GD25297@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2014年09月18日 04:13, Dmitry Torokhov 写道:
> On Wed, Sep 17, 2014 at 12:48:16PM -0700, Doug Anderson wrote:
>> Caesar,
>>
>> On Tue, Sep 16, 2014 at 8:59 PM, Caesar Wang <caesar.wang@rock-chips.com> wrote:
>>> This add the necessary binding documentation for the thermal
>>> found on Rockchip SoCs
>>>
>>> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
>>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>>> ---
>>>   .../bindings/thermal/rockchip-thermal.txt          | 41 ++++++++++++++++++++++
>>>   1 file changed, 41 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>>> new file mode 100644
>>> index 0000000..6fc8bc3
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>>> @@ -0,0 +1,41 @@
>>> +* Temperature Sensor ADC (TSADC) on rockchip SoCs
>>> +
>>> +Required properties:
>>> +- compatible: "rockchip,rk3288-tsadc"
>>> +- reg: physical base address of the controller and length of memory mapped
>>> +       region.
>>> +- interrupts: The interrupt number to the cpu. The interrupt specifier format
>>> +             depends on the interrupt controller.
>>> +- clocks: Must contain an entry for each entry in clock-names.
>>> +- clock-names: Shall be "tsadc" for the converter-clock, and "apb_pclk" for
>>> +              the peripheral clock.
>>> +- num-trips:  number of total trip points, this is required, set it 0 if none,
>>> +             if greater than 0, the following properties must be defined;
>> nit: there is whitespace damage (space before tab) on the line before
>> this one.  It's more obvious in the patch you uploaded to gerrit which
>> highlights this in red:
>>
>> https://chromium-review.googlesource.com/#/c/213967/5/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>>
>> Did you run your patches through checkpatch before submitting?
> FWIW vim users like me can put the following in their .vimrc file to
> have whitespace damage visible right away:
>
> :highlight RedundantSpaces ctermbg=red guibg=red
> :match RedundantSpaces /\s\+$\| \+\ze\t/
>
> Thanks.

It's a very useful, Thank you  for sharing.


-- 
Best regards,
Caesar


