Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaI3ITS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:19:18 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:55057 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaI3ITQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:19:16 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <44449a6527ce2da6c36d42193e08cbeb>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <542A6777.5070105@rock-chips.com>
Date: Tue, 30 Sep 2014 16:19:03 +0800
From: Mark yao <mark.yao@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org,
        linux-rockchip@lists.infradead.org, dianders@chromium.org,
        marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net,
        djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com,
        cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        yxj@rock-chips.com, wxt@rock-chips.com, xw@rock-chips.com
Subject: Re: [PATCH v8 2/3] dt-bindings: video: Add for rockchip display subsytem
References: <1412057386-19375-1-git-send-email-mark.yao@rock-chips.com> <1412057659-19483-1-git-send-email-mark.yao@rock-chips.com> <20140930081020.GE24667@phenom.ffwll.local>
In-Reply-To: <20140930081020.GE24667@phenom.ffwll.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月30日 16:10, Daniel Vetter wrote:
> On Tue, Sep 30, 2014 at 02:14:19PM +0800, Mark Yao wrote:
>> From: Mark yao <mark.yao@rock-chips.com>
>>
>> This add a display subsystem comprise the all display interface nodes.
>>
>> Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> Acked-by: Daniel Vetter <daniel@ffwll.ch>
>> Reviewed-by: Rob Clark <robdclark@gmail.com>
> Just a quick clarification: My ack was only about the drm driver itself, I
> try really hard to stay away from DT insanity ;-) So please drop my ack
> from these two patches.
>
> Aside: DT patches need to go through a special process and you must cc dt
> maintainers and mailing lists. Your patch seems to lack this, which afaiui
> is a blocker for merging the driver.
>
> Thanks, Daniel
Oh, I'm sorry, I will drop it soon.
>> ---
>> Changes in v2:
>> - add DRM master device node to list all display nodes that comprise
>>    the graphics subsystem.
>>
>> Changes in v3: None
>>
>> Changes in v4: None
>>
>> Changes in v5: None
>>
>> Changes in v6: None
>>
>> Changes in v7: None
>>
>> Changes in v8: None
>>
>>   .../devicetree/bindings/video/rockchip-drm.txt     |   19 +++++++++++++++++++
>>   1 file changed, 19 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/video/rockchip-drm.txt
>>
>> diff --git a/Documentation/devicetree/bindings/video/rockchip-drm.txt b/Documentation/devicetree/bindings/video/rockchip-drm.txt
>> new file mode 100644
>> index 0000000..7fff582
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/video/rockchip-drm.txt
>> @@ -0,0 +1,19 @@
>> +Rockchip DRM master device
>> +================================
>> +
>> +The Rockchip DRM master device is a virtual device needed to list all
>> +vop devices or other display interface nodes that comprise the
>> +graphics subsystem.
>> +
>> +Required properties:
>> +- compatible: Should be "rockchip,display-subsystem"
>> +- ports: Should contain a list of phandles pointing to display interface port
>> +  of vop devices. vop definitions as defined in
>> +  Documentation/devicetree/bindings/video/rockchip-vop.txt
>> +
>> +example:
>> +
>> +display-subsystem {
>> +	compatible = "rockchip,display-subsystem";
>> +	ports = <&vopl_out>, <&vopb_out>;
>> +};
>> -- 
>> 1.7.9.5
>>
>>


