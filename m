Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750931AbaLOKjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:39:10 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59302 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750716AbaLOKjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:39:07 -0500
Date: Mon, 15 Dec 2014 10:38:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Yakir Yang <ykk@rock-chips.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Daniel Kurtz <djkurtz@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Xu Jianqun <jay.xu@rock-chips.com>,
        =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Brian Austin <brian.austin@cirrus.com>,
        Bard Liao <bardliao@realtek.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Oder Chiou <oder_chiou@realtek.com>, alsa-devel@alsa-project.org,
        Arnd Bergmann <arnd@arndb.de>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, David Airlie <airlied@linux.ie>,
        Sean Cross <xobs@kosagi.com>, Grant Likely <grant.likely@linaro.org>,
        linux-rockchip@lists.infradead.org, Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Zhang <benzh@chromium.org>, devicetree@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Mark Rutland <mark.rutland@arm.com>, Jyri Sarha <jsarha@ti.com>
Subject: Re: [RFC PATCH 0/6] Those patches is used for dw_hdmi audio.
Message-ID: <20141215103830.GD11285@n2100.arm.linux.org.uk>
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:11:28AM +0800, Yakir Yang wrote:
> 
> rk3288 use Designware HDMI IP, Designware HDMI supports four interfaces to
> config hdmi audio(I2S, S/PDIF, Generic Parallel Audio, AHB Audio DMA), but
> rk3288 only support two ways to config hdmi audio(I2S, S/PDIF), So we take
> I2S as hdmi audio operation interfaces, and then treat hdmi audio as an
> standard ALSA devices(only got platback function).

There is no need for dw-hdmi audio to be implemented as an ASoC
device - as I've already sent patches to Andy with my ALSA driver
which has been around for the last two years, and works well, and
doesn't require any additional DT description.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
