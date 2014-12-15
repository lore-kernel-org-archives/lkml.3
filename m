Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaLOMDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:03:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60047 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaLOMDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:03:08 -0500
Date: Mon, 15 Dec 2014 12:02:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Yakir Yang <ykk@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
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
Message-ID: <20141215120205.GZ11764@sirena.org.uk>
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
 <1418612114-19692-1-git-send-email-ykk@rock-chips.com>
 <20141215104029.GE11285@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eVN8q1r3v0Uw6/qa"
Content-Disposition: inline
In-Reply-To: <20141215104029.GE11285@n2100.arm.linux.org.uk>
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


--eVN8q1r3v0Uw6/qa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 15, 2014 at 10:40:29AM +0000, Russell King - ARM Linux wrote:

> Including details like this (because ASoC needs a separate DT node) is
> the wrong approach.

And indeed there should be no Linux-internal reason for that - we should
be able to use whatever DT node makes sense, if there's some reason
that's not possible we should fix that (we do have several drivers doing
this sort of thing already though).

--eVN8q1r3v0Uw6/qa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUjs28AAoJECTWi3JdVIfQyuIIAIJDD10SCDDvHTyH/jpnvSpZ
g7ObS21UKrw3LuBbQkIPqAow0ixm6c3NudWxv8C1QX74osQgpWMFljUlUUDWYARm
Qbul4Sz49ab0HgNjV3848OQV0NmMGJLmEqCuAoCy0ayoHsUi3jJzgTFlQnfIvxr7
3y1OGXiZ+BTJLntRbpGbuUHZe36Q7/9YaN8lC+PPQo1MuE26Iz+66SucWT1iYvpb
i8KgkW5GATtGpWDSTZX/1SfE2kwwx5J9mWZs84MRe319mHHiL44CL6JboCnFt/Ev
45v15Sba3caEFqwxZB5NwhTlPINfstYG2ZeO11gTScAHgF3jY6VSiD0keOcK4rQ=
=9XaR
-----END PGP SIGNATURE-----

--eVN8q1r3v0Uw6/qa--
