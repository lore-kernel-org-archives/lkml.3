Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaILKMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:12:53 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:42210 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753949AbaILKMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:12:50 -0400
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: cf@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <fcc84501a54dd5d879890309f761edc3>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5412C6FA.9020308@rock-chips.com>
Date: Fri, 12 Sep 2014 18:12:10 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Jianqun <jay.xu@rock-chips.com>
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        huangtao@rock-chips.com, cf@rock-chips.com
Subject: Re: [PATCH 1/2] ASoC: rockchip-max98090: add documentation for rockchip-max98090
 driver
References: <1410507036-15442-1-git-send-email-jay.xu@rock-chips.com> <1410513055-17775-1-git-send-email-jay.xu@rock-chips.com> <3774516.jOvxH1lgyQ@diego>
In-Reply-To: <3774516.jOvxH1lgyQ@diego>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



在 09/12/2014 06:04 PM, Heiko Stübner 写道:
> Hi Jianqun,
> 
> Am Freitag, 12. September 2014, 17:10:55 schrieb Jianqun:
>> Add documentation for rockchip-max98090 driver, which is need by rockchip
>> board using a max98090.
>>
>> Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
>> ---
>> changes since v1:
> 
> please make sure to also include the version in the patch subject, so that
> people can always see which is which. This one should've been
> 
> [PATCH v2 1/2] ASoC: rockchip-max98090: add documentation for rockchip-max98090 driver
> 
> Because without this identification, people can only try to guess which one is the
> newest version.
> 
ok, thanks, I will notice this in the future
> 
> Heiko
> 
>> - modify error text from "Tegra" to "rockchip"
>>
>>  .../sound/rockchip,rockchip-audio-max98090.txt     | 23
>> ++++++++++++++++++++++ 1 file changed, 23 insertions(+)
>>  create mode 100644
>> Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.tx
>> t
>>
>> diff --git
>> a/Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.
>> txt
>> b/Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.
>> txt new file mode 100644
>> index 0000000..e12d1a0
>> --- /dev/null
>> +++
>> b/Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.
>> txt @@ -0,0 +1,23 @@
>> +ROCKCHIP audio complex, with MAX98090 CODEC
>> +
>> +Required properties:
>> +- compatible : must be "rockchip,rockchip-audio-max98090"
>> +- rockchip,model : the user-visible name of this sound complex
>> +- rockchip,i2s-controller : The phandle of the rockchip I2S controller
>> +  that's connected to the CODEC.
>> +- rockchip,audio-codec : The phandle of the MAX98090 audio codec.
>> +
>> +Optional properties:
>> +- rockchip,hp-det-gpios : The GPIO that detect headphones are plugged in
>> +- rockchip,mic-det-gpios : The GPIO that detect micphones are plugged in
>> +
>> +Example:
>> +
>> +sound {
>> +	compatible = "rockchip,rockchip-audio-max98090";
>> +	rockchip,model = "ROCKCHIP-I2S";
>> +	rockchip,i2s-controller = <&i2s>;
>> +	rockchip,audio-codec = <&max98090>;
>> +	rockchip,hp-det-gpios = <&gpio6 5 GPIO_ACTIVE_HIGH>;
>> +	rockchip,mic-det-gpios = <&gpio6 11 GPIO_ACTIVE_HIGH>;
>> +};
> 
> 
> 
> 
