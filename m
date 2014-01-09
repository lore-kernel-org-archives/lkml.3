Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaAIRi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:38:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50295 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaAIRit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:38:49 -0500
Date: Thu, 9 Jan 2014 17:38:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140109173843.GI12858@sirena.org.uk>
References: <1389260980-25579-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+PbGPm1eXpwOoWkI"
Content-Disposition: inline
In-Reply-To: <1389260980-25579-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Gravity brings me down.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: fix the cinfo error check
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+PbGPm1eXpwOoWkI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2014 at 05:49:40PM +0800, Xiubo Li wrote:
> If the dt is used and the cinfo is NULL, the -ENOMEM should be return.
>=20
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>

Applied, thanks.

--+PbGPm1eXpwOoWkI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzt6gAAoJELSic+t+oim9UMEP/jInEtKqv1VNVtmMRoJoxVCB
PcygOGo+mUSKLRHOESvUPmgX+r0FiEqDd3lY9wMc1YVCTyemSS9lnUl4z+zSofA0
GRpzFLLTFm6pkBL65hNVqXLwZTaePn/Tv5A5tFE3TUCQHqihm56rRxjT/QkCIM80
AtYL5mhk8eSu9T0BSEcyi5QxPzLSnZsgHEkCRB7QoMf9jCIkk/VX4dDLzSTSNLoJ
MAWxFG4ttaggwaUW9OUiUPdWhlb9NQ/BY5ITzPNwtoCmX5RMYLUEByEhOAEGnMxs
Px15+Xnc93mOsknaA7ehdc1p6NWYD3tRgzKJWTx/F1afJU7E2SzhZC3AOHhIRp/4
2d22+tWwrlcjgmyQ6jvM57Q5FeKWb+q5Z77KajRPUon4vhWm2jbzFYipEiYXQUXv
53pdRn/adPUsBHm7p9Py3DYe7n9f3AK06euO/Ek6JuTsaxojKZ6DX/QHnquTm5ni
LHGQtJEsbBqpGh0rw6SH2My7NbMEUCeA7FDyNY/F8eK2Ehzkb/rsM9/hy7kixvbL
OpHTwA+UnBoKfvgf4sTulhaIvopu6p/SuPlCr9kzhOcH7+L9qT6zKWrM/rS13r3V
5DZdNWTIPP2a73aom/gRsfZxC17R2FYD3XgtmKPl5J4zCawc9ViZfF2mLDkICrh1
Ij+IqJ+j4Eg4pz6qoN1G
=x5f+
-----END PGP SIGNATURE-----

--+PbGPm1eXpwOoWkI--
