Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaI1Ayh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 20:54:37 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:45554 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaI1Ayg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 20:54:36 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: cf@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <ebd90401e9a88b293a95c797f3dbc821>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <54275C43.8010205@rock-chips.com>
Date: Sun, 28 Sep 2014 08:54:27 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Jianqun <jay.xu@rock-chips.com>
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, heiko@sntech.de,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        huangtao@rock-chips.com, cf@rock-chips.com
Subject: Re: [PATCH 1/2] ASoC: rockchip-max98090: add documentation for rockchip-max98090
 driver
References: <1410506806-15327-1-git-send-email-jay.xu@rock-chips.com> <1410507036-15442-1-git-send-email-jay.xu@rock-chips.com> <20140912134446.GT7960@sirena.org.uk>
In-Reply-To: <20140912134446.GT7960@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



在 09/12/2014 09:44 PM, Mark Brown 写道:
> On Fri, Sep 12, 2014 at 03:30:36PM +0800, Jianqun wrote:
>> Add documentation for rockchip-max98090 driver, which is need by rockchip
>> board using a max98090.
> 
> Can this use simple-card (perhaps after a bit of extension)?
I haven't ever try simple-card, is there any sample usage for me from other vendor ?
> 
>> +- rockchip,audio-codec : The phandle of the MAX98090 audio codec.
> 
> Is the driver really specific to this CODEC?
I think yes, we need to add two gpio for mic and hp detect, but simple-card driver hasn't them
> 
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
>> -- 
>> 1.9.1
>>
>>
>>

-- 
Jianqun Xu

****************************************************************************
*IMPORTANT NOTICE:*This email is from Fuzhou Rockchip Electronics Co.,
Ltd .The contents of this email and any attachments may contain
information that is privileged, confidential and/or exempt from
disclosure under applicable law and relevant NDA. If you are not the
intended recipient, you are hereby notified that any disclosure,
copying, distribution, or use of the information is STRICTLY PROHIBITED.
Please immediately contact the sender as soon as possible and destroy
the material in its entirety in any format. Thank you.
****************************************************************************

