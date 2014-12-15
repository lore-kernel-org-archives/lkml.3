Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaLOPrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:47:47 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:53913 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaLOPrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:47:42 -0500
Date: Mon, 15 Dec 2014 16:48:08 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Kuankuan.Yang" <ykk@rock-chips.com>, Mark Rutland <mark.rutland@arm.com>,
        Heiko Stuebner <heiko@sntech.de>, devicetree@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Liam Girdwood <lgirdwood@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Bard Liao <bardliao@realtek.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Pawel Moll <pawel.moll@arm.com>, Takashi Iwai <tiwai@suse.de>,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Dylan Reid <dgreid@chromium.org>, Xu Jianqun <jay.xu@rock-chips.com>,
        Oder Chiou <oder_chiou@realtek.com>, Zubair.Kakakhel@imgtec.com,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jyri Sarha <jsarha@ti.com>, Ben Zhang <benzh@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Daniel Kurtz <djkurtz@chromium.org>,
        =?UTF-8?B?U3TDqXBoYW5l?= Marchesin <marcheu@chromium.org>,
        Jaroslav Kysela <perex@perex.cz>, Sonny Rao <sonnyrao@chromium.org>,
        Sean Cross <xobs@kosagi.com>, linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Brian Austin <brian.austin@cirrus.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [RFC PATCH 0/6] Those patches is used for dw_hdmi audio.
Message-ID: <20141215164808.092cc7ac@armhf>
In-Reply-To: <20141215120013.GH11285@n2100.arm.linux.org.uk>
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
	<20141215103830.GD11285@n2100.arm.linux.org.uk>
	<548EC9E1.5040206@rock-chips.com>
	<548ECB66.70004@rock-chips.com>
	<20141215120013.GH11285@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2014 12:00:13 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> I really don't want to end up in another cocked up situation like
> what happened with the Dove audio, where it became politically
> impossible for the SolidRun platform to be properly supported by
> mainline kernels.

Hi Russell,

I don't see what you mean. The last patches I proposed for the TDA998x
and the HDMI CODEC do exactly what you wanted: S/PDIF out from the
kirkwood audio device towards both S/PDIF optical and HDMI output2 by
default.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
