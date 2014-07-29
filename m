Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaG2Jwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:52:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60831 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaG2Jw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:52:29 -0400
Date: Tue, 29 Jul 2014 10:52:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Fabio Estevam <festevam@gmail.com>, Nicolin Chen <nicoleotsuka@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        patches@opensource.wolfsonmicro.com, b02247@freescale.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nicolin Chen <b42378@freescale.com>
Message-ID: <20140729095203.GK17528@sirena.org.uk>
References: <1406547718-21498-1-git-send-email-nicoleotsuka@gmail.com>
 <20140728122211.GS17528@sirena.org.uk>
 <CAOMZO5DgE9RjC9MG7FbGPKwsgxunntw70W6Sj8WQKFYG+j8BsA@mail.gmail.com>
 <20140729025518.GB3350@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EcvL2e2K6sUZje1U"
Content-Disposition: inline
In-Reply-To: <20140729025518.GB3350@MrMyself>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v2] ASoC: wm8962: Let CODEC driver enable
 and disable its own MCLK
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EcvL2e2K6sUZje1U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 10:55:19AM +0800, Nicolin Chen wrote:
> On Mon, Jul 28, 2014 at 03:19:43PM -0300, Fabio Estevam wrote:

> > >> +     pdata->mclk =3D devm_clk_get(&i2c->dev, NULL);

> > > This is broken for deferred probe.

> Sorry. I don't get why deferred probe would be broken by this.
> And I just took a test by adding this:

I don't see the code that actually pays attention to the return value
=66rom devm_clk_get() - in the main probe function the code just treats
all errors as a missing MCLK.

--EcvL2e2K6sUZje1U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT127AAAoJELSic+t+oim9/lwP/21qj6AX7PQWwHuaoJomeq1h
ldrF+SHto0h+X8/JPh7MFmhStISiX7bNI/jue5nNbkJZtyruGm9RxO2G19qBtcJC
yN9jCIC/ftBtdQBWYjIRhhQbQmrlLmQhivQuFujgo/c/QMbcOnM/oPj1ABv1Y1dc
9bwJOADRIw0pGBdsi2FiLcU847QEmm4WaXXAojbHssVXpPDo7QLz5Kq9vqDSJeT/
h127fZvGZ9Dl6EPXbbCpbBacPNhpXmGTRiwvmzVfmiQmT7IdRAAPZSuW/vrdKjaz
RH8FNzXOHORjxm/MtFY7LNVaYxJyswmGFg6u9Y6dA6g4IYyM59iaDstpX+cjwRHu
lQNlPCl8axIFasggCvC6iUjHTolhOSx2QkJ3xHOCGU7cvTF9wlMAOZRLabTIkKTe
nivpW3/w6we2Nm/TY5Dx4+/AIG4WzWXVmjRTDfLGSSDtOxJ2cmfSVSr/6YvKn9X8
aqQJx4i77UdAnUTVPtYgS6JzYGIdbbSIOpHTzpv7o7LdlXIe+PzVZuO6UMIu+kQu
9+dtmcBJNgb7laDNCdVcEFa6RVEa/CMxuL94FU2aenU+UIkCUFKpLcemX9Y1w3hM
I8SQ6IrbHtd0NeC/PM/x4t17tGPcag3qR1YclMP8Ch9NE1U+3/lpnd5MDX6AVOrL
AJs+bUpoQx6IjhcnTpXN
=cXEu
-----END PGP SIGNATURE-----

--EcvL2e2K6sUZje1U--
