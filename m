Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbaLOKk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:40:58 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59351 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750737AbaLOKky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:40:54 -0500
Date: Mon, 15 Dec 2014 10:40:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Yakir Yang <ykk@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, dri-devel@lists.freedesktop.org,
        Daniel Kurtz <djkurtz@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Xu Jianqun <jay.xu@rock-chips.com>,
        =?utf-8?B?U3Tvv73vv71waGFuZQ==?= Marchesin <marcheu@chromium.org>,
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
        Jaroslav Kysela <perex@perex.cz>, Mark Brown <broonie@kernel.org>,
        Takashi Iwai <tiwai@suse.de>, Jyri Sarha <jsarha@ti.com>
Subject: Re: [PATCH 5/6] dt-bindings: Add documentation for Rockchip
 hdmi-audio
Message-ID: <20141215104029.GE11285@n2100.arm.linux.org.uk>
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
 <1418612114-19692-1-git-send-email-ykk@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418612114-19692-1-git-send-email-ykk@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:55:14AM +0800, Yakir Yang wrote:
> Required properties:
> - compatible: platform specific
> - cpu-of-node: the device node of cpu_dai
> - codec-name: the dw-hdmi codec's device name
> - codec-dai-name: the dw-hdmi codec's dai name

This is not actually a separate physical device from the main dw-hdmi
device.  What you are doing is merely describing the Linux kernel
internals in DT, which is not what DT is supposed to be about.  DT is
supposed to describe the hardware in an operating system independent
manner.

Including details like this (because ASoC needs a separate DT node) is
the wrong approach.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
