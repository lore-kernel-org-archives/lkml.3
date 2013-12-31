Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3LaMVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 07:21:09 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46281 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3LaMVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 07:21:06 -0500
Date: Tue, 31 Dec 2013 12:20:36 +0000
From: Mark Brown <broonie@kernel.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131231122036.GM31886@sirena.org.uk>
References: <1388114078-24517-1-git-send-email-Li.Xiubo@freescale.com>
 <20131230121113.GQ31886@sirena.org.uk>
 <4c44077c52604d0b85c4babb59268eb7@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wm6Et8bt556AKwYA"
Content-Disposition: inline
In-Reply-To: <4c44077c52604d0b85c4babb59268eb7@BY2PR03MB505.namprd03.prod.outlook.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: cleanup asoc_simple_card_parse_of()
 code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wm6Et8bt556AKwYA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 31, 2013 at 03:27:53AM +0000, Li.Xiubo@freescale.com wrote:

> Also, for most of the devices of the same DAI link, they use the same DAI
> formats, but I have found some drivers like : "sound/soc/pxa/magician.c"
> and "sound/soc/s6000/s6105-ipcam.c", etc, may have different DAI format
> settings for some reasons(maybe some formats are the CPU/Codec devices
> default setting that it needn't set it here or others).

The ipcam still has that?  It was supposed to have been fixed before it
was merged since it was identified as a bug in the CPU DAI during review. =
=20
I don't know about magician since it was before my time but I suspect it
suffers from the same issue or that there's something else in there that
needs some other hardware more explicitly representing.

> I think maybe this is also the reason why the simple-card has common DAI
> format and CPU/CODEC private DAI formats at the same time.

I'd really want to see a real use case that actually was a simple card.

--Wm6Et8bt556AKwYA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwraRAAoJELSic+t+oim98F4P/icaQXNJIiARIwWF3E0JaXev
kpiIwjWbTq7RX4icZTMfwVgWJMNBtQyP6+RM9aQZESUFdMljjV9tiKI/tOOefuka
5lZDwgf48YwctZxfHvYepxmggQbyLEaPfUzFX3YqBB426MTcDYOSZk2SgZrz9aEL
F5cl0qGDy/iF+456K+JOHGVjGZoz8nljdGuaSCrmCIa5EHH0I98hrwF+CijGV7Nc
rET6aOkQJoJ6mfXewIg32xHr6vpMvP7kVc0dC910NHltW4RAptHYRYSJqfi/J+0Z
fMLgTEPpNhBQ74qMl3YcYvo3BBjH+Nh6ZCZG+z0CCW5ik8Nao494kGkmSnmd8nAh
FbKiwCjK+0F8fgXX/xDPZ07iEv8ipzcnqn4PThbSJAYSl3L0uShGy9EQ+INUvvbM
byLLvCIMLShQu59FhM1oJWq5LBgoVZg//0hfuYt4QxaIYrFrKW8t8IAhnmXxHYJr
X21pf2OZvsNpAZc1d1/yf6W6h911kZzyWUPUzObIsvmaBnAs5RMwE7WxbYOVDIt1
7BUd5w4zOf4KuCVc41TBgMyXcy87ekQqKCjPXi5+onM0MN8G91xW/xtCDO6PnDvx
KBoqL7wHWdCFg4yRroOnWtc1IdWFIirJhq+RMYc++03bWqtmkA++FpUm5wgbQZbk
QGJHYqrwZWOBoZ4UvKnw
=zn/2
-----END PGP SIGNATURE-----

--Wm6Et8bt556AKwYA--
