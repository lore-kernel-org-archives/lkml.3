Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaLHLPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:15:50 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51929 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbaLHLPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:15:49 -0500
Date: Mon, 8 Dec 2014 11:14:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Zidan Wang <B50113@freescale.com>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141208111445.GT11764@sirena.org.uk>
References: <1417696879-15402-1-git-send-email-b50113@freescale.com>
 <20141205170156.GB14516@opensource.wolfsonmicro.com>
 <20141205173932.GN11764@sirena.org.uk>
 <BN3PR0301MB12511B448B1C0B9E8F0BB6C48D640@BN3PR0301MB1251.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wiiWofWi8Et/oezL"
Content-Disposition: inline
In-Reply-To: <BN3PR0301MB12511B448B1C0B9E8F0BB6C48D640@BN3PR0301MB1251.namprd03.prod.outlook.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel][PATCH v3] ASoC: wm8960: Let wm8960 codec driver
 manage its own MCLK
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wiiWofWi8Et/oezL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2014 at 09:49:51AM +0000, Zidan Wang wrote:
> So I should move mclk to wm8960_priv.=20
> And doing wm8960_priv->mclk =3D devm_clk_get(&i2c->dev, "codec_mclk") in =
wm8960_i2c_probe.

Yes, please.

--wiiWofWi8Et/oezL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUhYgkAAoJECTWi3JdVIfQg/YIAIagOEIeJKVoDG4UjRSEsmN7
vGCXi3c/1CGzE0LwDAsScFBEEboeBeWjtgbu18H3IkBLvBpeU2GDM1l0dmWcrScI
sNeKLp3Q8zPd79dfgKAbNQm3YiwSARLviax8RN4xRBgxJuby97jnmMDONftJHQhn
kz72pLs67jQfTJzXOgItp0OwPuapBcA7KAR5jRVcyDlAbnVcirBXPeY//6hFv5tO
CDvlIcqQwdy5f0r+SALuuk2axgzV5ylqh6B9FSMs+TRPVIBLrJXFQ+BwGfOTnVP5
5/R02QefR3dhLh6ujObJi+cNMXHCumH8YzaLy88x1RzagZoL0bYxCLa0Vm4tGLU=
=T7OE
-----END PGP SIGNATURE-----

--wiiWofWi8Et/oezL--
