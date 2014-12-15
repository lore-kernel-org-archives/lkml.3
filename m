Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaLOJrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:47:09 -0500
Received: from regular1.263xmail.com ([211.150.99.138]:48184 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaLOJrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:47:06 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: ykk@rock-chips.com
X-FST-TO: jsarha@ti.com
X-SENDER-IP: 104.167.231.7
X-LOGIN-NAME: ykk@rock-chips.com
X-UNIQUE-TAG: <99e6c404e4f96a36eae5aa8b81eed6fd>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <548EADFB.6020903@rock-chips.com>
Date: Mon, 15 Dec 2014 17:46:35 +0800
From: "Kuankuan.Yang" <ykk@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, dri-devel@lists.freedesktop.org,
        Daniel Kurtz <djkurtz@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Xu Jianqun <jay.xu@rock-chips.com>,
        =?UTF-8?B?U3Tvv73vv71waGFuZSBNYXJjaGVzaW4=?= <marcheu@chromium.org>,
        Brian Austin <brian.austin@cirrus.com>,
        Bard Liao <bardliao@realtek.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Oder Chiou <oder_chiou@realtek.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        Arnd Bergmann <arnd@arndb.de>, David Airlie <airlied@linux.ie>,
        Sean Cross <xobs@kosagi.com>, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Zhang <benzh@chromium.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Mark Brown <broonie@kernel.org>,
        Takashi Iwai <tiwai@suse.de>, Jyri Sarha <jsarha@ti.com>
Subject: Re: [PATCH 5/6] dt-bindings: Add documentation for Rockchip hdmi-audio
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com> <1418612114-19692-1-git-send-email-ykk@rock-chips.com> <548EA3B9.5080407@metafoo.de>
In-Reply-To: <548EA3B9.5080407@metafoo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lars:

thks for your review, I will move it to hdmi audio driver, give the 
codec_name & codec_dai_name an const string.

Best Regards.

在 2014年12月15日 17:02, Lars-Peter Clausen 写道:
> On 12/15/2014 03:55 AM, Yakir Yang wrote:
> [...]
>> +- codec-name: the dw-hdmi codec's device name
>> +- codec-dai-name: the dw-hdmi codec's dai name
>
> Please you phandles for this, the names are Linux driver and framework 
> specific details. That should not leak into the DT bindings.
>
> [..]
>
>
>


