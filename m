Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaCGBrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:47:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57119 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaCGBrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:47:40 -0500
Date: Thu, 6 Mar 2014 17:46:53 +0800
From: Mark Brown <broonie@kernel.org>
To: Nenghua Cao <nhcao@marvell.com>
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20140306094653.GQ13126@sirena.org.uk>
References: <1392806698-29638-1-git-send-email-nhcao@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUETZ9jfdlrBCYso"
Content-Disposition: inline
In-Reply-To: <1392806698-29638-1-git-send-email-nhcao@marvell.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] asoc: soc-core: use regmap's parse_val to do endian
 translation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUETZ9jfdlrBCYso
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2014 at 06:44:58PM +0800, Nenghua Cao wrote:
> From: Nenghua Cao <nhcao@marvell.com>
>=20
>     In snd_soc_bytes_put function, it forces cpu to do cpu_to_be translat=
ion,
> but for mmio bus which uses REGMAP_ENDIAN_NATIVE, it doesn't need to do
> endian translation. So it is better to use regmap's api which can decide
> if this translation is needed according to bus configuration.

Applied, thanks.

--fUETZ9jfdlrBCYso
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTGEQKAAoJELSic+t+oim9GsQP/RhbFwi3AILapJ1PFmqPsE2v
HWYTXrELzByMedvdxtwGo8j5twxiUVhVkvgWQQIVsxieDKK9rtn2534ZNt2HBDyI
gdfXP/pGzPXQFxs/FRR1nDz223dVQ3TUd1GpmdLu1wcv0HsXerhscxv61xlmfRag
lvWyvx9zkklX2Zk2N8Euz5Vos6AG8FxOL2zhO+PEuOf5//L+erfeTgorvVUnaDfr
mk5GWGF8WgReRWUKFGmr9TiajMmQ8Ldgsbh4gVyitS2uJAogEKuNIrzqyUIDe7/4
bYiKLUXR0N4/e3OgFqN8r15WneT5X4Dxitkd9nZo9Gin2Km4zYiLcZLRKCEa6gva
MRKfdvDQZjddx9VM795gGRHalQhh9Ef10RelLhghPIr70ryQMHl6+/hGflxFzP/j
3u3tEjsZT0Kjbf3eKPn2brVh+XhVgOlgRyzLeR3BzMVgIaStocwbZOb2280xBfCO
KYEkWUGipbymy9fkeFbZZf0weT41vU30/B8zKNNAwraw/RO/kOMGXHmNYYtFz6D/
XtZ4LFPyFRTk3EJkEC8Jzuo9beHlUM8kyX/QglmWl7bmg3hHINb5tGhy88kUY3fz
Q36b2WzzeG7YCZOem1xHkQBdlFKwbAX1pwoCrkAQMOL55zZibETwrqRQk8KuYdJN
SHR8DzikdPqdv3zm+pjC
=WWnA
-----END PGP SIGNATURE-----

--fUETZ9jfdlrBCYso--
