Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaLCL7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:59:46 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:60391 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaLCL7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:59:03 -0500
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: l.stach@pengutronix.de
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <70e0cef6140cdd9add7732c041d9fe82>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547EFAE6.9050404@rock-chips.com>
Date: Wed, 03 Dec 2014 19:58:30 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Mark Rutland <mark.rutland@arm.com>, heiko@sntech.de, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, ykk@rock-chips.com,
        devel@driverdev.osuosl.org, Pawel Moll <pawel.moll@arm.com>,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, jay.xu@rock-chips.com,
        devicetree@vger.kernel.org, Zubair.Kakakhel@imgtec.com,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, rmk+kernel@arm.linux.org.uk,
        mark.yao@rock-chips.com, fabio.estevam@freescale.com,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, djkurtz@google.com,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        vladimir_zapolskiy@mentor.com, Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v15 06/12] dt-bindings: add document for dw_hdmi
References: <1417505778-18341-1-git-send-email-andy.yan@rock-chips.com>	 <1417506124-18626-1-git-send-email-andy.yan@rock-chips.com>	 <1417544629.3411.15.camel@pengutronix.de> <547EDBEE.70700@rock-chips.com> <1417607520.5124.8.camel@pengutronix.de>
In-Reply-To: <1417607520.5124.8.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014年12月03日 19:52, Philipp Zabel wrote:
> Am Mittwoch, den 03.12.2014, 17:46 +0800 schrieb Andy Yan:
>> On 2014年12月03日 02:23, Philipp Zabel wrote:
>>> Hi Andy,
>>>
>>> Am Dienstag, den 02.12.2014, 15:42 +0800 schrieb Andy Yan:
>>>> diff --git a/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt b/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
>>>> new file mode 100644
>>>> index 0000000..107c1ca
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
>>>> @@ -0,0 +1,40 @@
>>>> +DesignWare HDMI bridge bindings
>>>> +
>>>> +Required properities:
>>>> +- compatible: platform specific such as:
>>>> +   * "fsl,imx6q-hdmi"
>>>> +   * "fsl,imx6dl-hdmi"
>>>> +   * "rockchip,rk3288-dw-hdmi"
>>> I think we should add a common compatible value "snps,dw-hdmi-tx" here:
>>>
>>> 	compatible = "fsl,imx6q-hdmi", "snps,dw-hdmi-tx";
>>>
>>>> +- reg: Physical base address and length of the controller's registers.
>>>> +- ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
>>> Better make ddc-i2c-bus optional, see the other thread about the ddc i2c
>>> master.
>>       I have the same idea too, but the patch about ddc i2c master has not
>>    landed yet,  can we change the ddc-i2c-bus to optional  after the ddc
>> i2c master
>>    patch land?
> Check out Documentation/devicetree/bindings/drm/imx/hdmi.txt, it was
> already marked as optional. We can't make it required now.
>
> regards
> Philipp
>
>
>
   OK, got it, thanks

