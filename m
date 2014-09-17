Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbaIQSbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:31:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48490 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbaIQSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:31:36 -0400
Date: Wed, 17 Sep 2014 11:30:43 -0700
From: Mark Brown <broonie@kernel.org>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: timur@tabi.org, nicoleotsuka@gmail.com, Li.Xiubo@freescale.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, mpa@pengutronix.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140917183043.GR7960@sirena.org.uk>
References: <5dc0f13cdb62904ae0f104f9112faec672adea6f.1410833402.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SorlIzCW0DSU55cr"
Content-Disposition: inline
In-Reply-To: <5dc0f13cdb62904ae0f104f9112faec672adea6f.1410833402.git.shengjiu.wang@freescale.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4] ASoC: fsl_ssi: refine ipg clock usage in this module
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SorlIzCW0DSU55cr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 16, 2014 at 10:13:16AM +0800, Shengjiu Wang wrote:
> Check if ipg clock is in clock-names property, then we can move the
> ipg clock enable and disable operation to startup and shutdown, that
> is only enable ipg clock when ssi is working and keep clock is disabled
> when ssi is in idle.
> But when the checking is failed, remain the clock control as before.

Applied, thanks.

--SorlIzCW0DSU55cr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGdNOAAoJECTWi3JdVIfQMDYH/RwLDNitdtxPsO8VST2UHb0E
IGx1uWvA+yJTVbJguO5NPuUWasSEgAzjBWPOxhsNNPOeKVut+LM1G633uZmLGlI+
nqSwjIYmrH1SWBy9Inw0sfJMgcvbZ1i2jfTHb8Fpkc3GgKQb95Hy6nTz+2PqxINu
x2hrVCpsf/1IjHcE56G47bLpXEHuyfqwRN1XxCbmX4Y8U+avQ/PPUVwW0f14s/Zm
VMvTZveqoLGg9V53TaCGXv/7JF9StICmZG3rEzmhIG7SXyOfUPwSYNvqaUY03g8L
Lr/dtHZ419yjLHXJICj4NbV+823G3f4iAPpZYk7+NWGEO/TZV70FzgBb3ziXi3Y=
=G/8g
-----END PGP SIGNATURE-----

--SorlIzCW0DSU55cr--
