Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaLOQTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:19:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60554 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaLOQTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:19:47 -0500
Date: Mon, 15 Dec 2014 16:18:27 +0000
From: Mark Brown <broonie@kernel.org>
To: "Kuankuan.Yang" <ykk@rock-chips.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
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
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jyri Sarha <jsarha@ti.com>
Message-ID: <20141215161827.GE11764@sirena.org.uk>
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
 <1418612114-19692-1-git-send-email-ykk@rock-chips.com>
 <20141215104029.GE11285@n2100.arm.linux.org.uk>
 <20141215120205.GZ11764@sirena.org.uk>
 <548EDDC2.9050104@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C64opeEuicNVb5KK"
Content-Disposition: inline
In-Reply-To: <548EDDC2.9050104@rock-chips.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/6] dt-bindings: Add documentation for Rockchip
 hdmi-audio
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C64opeEuicNVb5KK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 15, 2014 at 09:10:26PM +0800, Kuankuan.Yang wrote:
> Hi Mark & Russell:

Please don't top post, that way people have some context for what you're
saying - look at how people normally format their mails on thelist.

> In that way, dt will only need compatible for creating sound device. is it
> ok  ?
> sound {
>     compatible = "rockchip,rk3288-hdmi-audio";
>     status = "okay";
> }
> could you give me some advises.

That'd be good, though the other question is if this can be made to use
simple-card so we can avoid having a custom driver for this.

--C64opeEuicNVb5KK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUjwnSAAoJECTWi3JdVIfQmAwH/0hdq6BjZ9xYACE0CunvAQcQ
sBdvJEB0SF8PplZgNYZo+I3FR9J/DgW5cWdO3hyNZtWzgQaQbhUwmbPy5lAfkVqU
sUhCYsXgGJorvFVdmF2/hUOt4fjwJ/+DwmbLmf7x075P+BecgL27DxIF5PoJKOzT
PCGxqlnnpcEyyULR7h6ZITB7LpakyvFq9ZVvvdKqZgBhPYAp16EWk6Dn+LmYVFXC
vXDST0SMgbWAylzHEPQMpmQQbU9ahF4m3nb2PR+9RF09EopV1hM/NMWPXWyn04+7
RfWoJIYqNavnIXptNKnAwXF1nCqjx/D4kKBBdobCyXaD1R7eOrv1y+ZF20yjLiY=
=ZeYG
-----END PGP SIGNATURE-----

--C64opeEuicNVb5KK--
