Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaJOJlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:41:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55326 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaJOJls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:41:48 -0400
Date: Wed, 15 Oct 2014 11:41:27 +0200
From: Mark Brown <broonie@kernel.org>
To: Thomas Abraham <thomas.ab@samsung.com>
Cc: lgirdwood@gmail.com, kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org
Message-ID: <20141015094127.GX27755@sirena.org.uk>
References: <1413274663-8836-1-git-send-email-thomas.ab@samsung.com>
 <20141014115514.GR27755@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8rwPx/46nQniO+If"
Content-Disposition: inline
In-Reply-To: <20141014115514.GR27755@sirena.org.uk>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: s2mps11: add support for S2MPS15 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8rwPx/46nQniO+If
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2014 at 01:55:14PM +0200, Mark Brown wrote:
> On Tue, Oct 14, 2014 at 01:47:43PM +0530, Thomas Abraham wrote:
> > The S2MPS15 PMIC is similar in functionality to S2MPS11/14 PMIC. It con=
tains
> > 27 LDO and 10 Buck regulators and allows programming these regulators v=
ia a
> > I2C interface. This patch adds initial support for LDO/Buck regulators =
of
> > S2MPS15 PMIC.
>=20
> Applied, thanks.

=2E..and reverted since it doesn't build due to depending on a header
that's not present in the tree.

--8rwPx/46nQniO+If
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUPkFGAAoJECTWi3JdVIfQP4sH/RmNW+ox/1mIJ6+cVcTg6b8c
+Soowqbu4yDDJp1N4SAcBNrz333gEL0jxG3jJd2Snkek/2PmC4FhFG7mi2/c4vJX
qaOqGwpmcDi0XUb34MQ3DSpU2vlwdoR/piQVEJw3NFOvzsUqJPu7ypnDMXjbws2o
BzzOKCzmTsV9kJi2yBNRHJ9mCMC62VtpEctlGvdATOUArAvWwoCc/zezjvV58sKg
IF/cmDFKW+8ztFaeVnPUr/ECyMdNzxiBTZGP8fg5c07C+fZkFioL/Ed9zcL86Wf4
7rmdAYh+Ul6CilobRPowI5kag5H53Eq0l29weuZJJ9GwXYQbE1+98//FH2/U4P4=
=eEYO
-----END PGP SIGNATURE-----

--8rwPx/46nQniO+If--
