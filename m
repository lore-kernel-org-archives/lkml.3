Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105AbaLPCis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:38:48 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:60259 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaLPCir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:38:47 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: ykk@rock-chips.com
X-FST-TO: jsarha@ti.com
X-SENDER-IP: 104.167.231.21
X-LOGIN-NAME: ykk@rock-chips.com
X-UNIQUE-TAG: <60d51f8eea06bc37a93d203a9658c2d6>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <548F9B27.9070008@rock-chips.com>
Date: Tue, 16 Dec 2014 10:38:31 +0800
From: "Kuankuan.Yang" <ykk@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, dri-devel@lists.freedesktop.org,
        Daniel Kurtz <djkurtz@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Xu Jianqun <jay.xu@rock-chips.com>,
        =?UTF-8?B?U3Tvv73vv71waGFuZSBNYXJjaGVzaW4=?= <marcheu@chromium.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Brian Austin <brian.austin@cirrus.com>,
        Bard Liao <bardliao@realtek.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Oder Chiou <oder_chiou@realtek.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        Arnd Bergmann <arnd@arndb.de>, David Airlie <airlied@linux.ie>,
        Sean Cross <xobs@kosagi.com>, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Zhang <benzh@chromium.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jyri Sarha <jsarha@ti.com>
Subject: Re: [PATCH 5/6] dt-bindings: Add documentation for Rockchip hdmi-audio
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com> <1418612114-19692-1-git-send-email-ykk@rock-chips.com> <20141215104029.GE11285@n2100.arm.linux.org.uk> <20141215120205.GZ11764@sirena.org.uk> <548EDDC2.9050104@rock-chips.com> <20141215161827.GE11764@sirena.org.uk>
In-Reply-To: <20141215161827.GE11764@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2014年12月16日 00:18, Mark Brown 写道:
> On Mon, Dec 15, 2014 at 09:10:26PM +0800, Kuankuan.Yang wrote:
>> Hi Mark & Russell:
> Please don't top post, that way people have some context for what you're
> saying - look at how people normally format their mails on thelist.

got it,  thanks for your remind.

>> In that way, dt will only need compatible for creating sound device. is it
>> ok  ?
>> sound {
>>      compatible = "rockchip,rk3288-hdmi-audio";
>>      status = "okay";
>> }
>> could you give me some advises.
> That'd be good, though the other question is if this can be made to use
> simple-card so we can avoid having a custom driver for this.


