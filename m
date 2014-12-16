Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaLPJf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:35:29 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33375 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751008AbaLPJfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:35:25 -0500
Date: Tue, 16 Dec 2014 09:34:43 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kuankuan.Yang" <ykk@rock-chips.com>
Cc: Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        alsa-devel@alsa-project.org, Heiko Stuebner <heiko@sntech.de>,
        devicetree@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Liam Girdwood <lgirdwood@gmail.com>,
        Max Filippov <jcmvbkbc@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>, linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Dylan Reid <dgreid@chromium.org>, Xu Jianqun <jay.xu@rock-chips.com>,
        Oder Chiou <oder_chiou@realtek.com>, Zubair.Kakakhel@imgtec.com,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jyri Sarha <jsarha@ti.com>, Ben Zhang <benzh@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Daniel Kurtz <djkurtz@chromium.org>,
        =?utf-8?B?U3Tvv73vv71waGFuZQ==?= Marchesin <marcheu@chromium.org>,
        Jaroslav Kysela <perex@perex.cz>, Sonny Rao <sonnyrao@chromium.org>,
        Sean Cross <xobs@kosagi.com>, linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Brian Austin <brian.austin@cirrus.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 5/6] dt-bindings: Add documentation for Rockchip
 hdmi-audio
Message-ID: <20141216093443.GN11285@n2100.arm.linux.org.uk>
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
 <1418612114-19692-1-git-send-email-ykk@rock-chips.com>
 <20141215104029.GE11285@n2100.arm.linux.org.uk>
 <20141215120205.GZ11764@sirena.org.uk>
 <548EDDC2.9050104@rock-chips.com>
 <20141215161827.GE11764@sirena.org.uk>
 <548FCE8F.7090106@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548FCE8F.7090106@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 02:17:51PM +0800, Kuankuan.Yang wrote:
> hdmi-audio driver share irq with dw_hdmi driver,  for continuing AHBAUDDMA
> or for detecting hdmi insert.
> So maybe it's hard to switch to simple-card way,  Russell what's your
> opinion ?

My "opinion" is that I need to spend some time looking in depth at both
your code and my code before I can form an idea of how to proceed.

However, since I seem to be spending a lot of time chasing regressions
which have appeared in v3.18, I don't have a lot of time to look at this
right now.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
