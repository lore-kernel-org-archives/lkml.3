Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbbAZVAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:00:41 -0500
Received: from sauhun.de ([89.238.76.85]:57345 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbbAZVAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:00:38 -0500
Date: Mon, 26 Jan 2015 22:00:31 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Bob Mottram <bob.mottram@codethink.co.uk>, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] i2c: tegra: Maintain CPU endianness
Message-ID: <20150126210031.GC28095@katana>
References: <1422291305-32514-1-git-send-email-digetx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E13BgyNx05feLLmH"
Content-Disposition: inline
In-Reply-To: <1422291305-32514-1-git-send-email-digetx@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E13BgyNx05feLLmH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 26, 2015 at 07:55:02PM +0300, Dmitry Osipenko wrote:
> Support CPU BE mode by adding endianness conversion for memcpy interactio=
ns.
>=20
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> Acked-by: Alexandre Courbot <acourbot@nvidia.com>

Applied to for-next, thanks!


--E13BgyNx05feLLmH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxqrvAAoJEBQN5MwUoCm2noQP/28/dFouVahtYBw0ohg2LzFZ
WmR67ga4N7JBHYW8FrYcCv1TQO8Z8BC85G7iWGH8R5fviYvcoIW48khYO+3FxCsY
7g6x9RNhM11NE4HjZ73Zo50/WlTI47c6v6mUCZwWiuB14pILPaBSLAdwl13XX6iN
RxaJhMh3ofAHiQr3TLKFe9CRSWVNDbjOZQU+D1TLAb59bKWNsvCrb7/55MCa2F05
k6OJTDNEsljbspaE8HVqxPJs2YAiuZx+/dro/abYQTBW8YZFOkKDEyuvoek1Cc1+
bM7amYYPGFiJZqcGfhzhWoxQ+GNPYwaYHHFW/6hAQXnVaAyZBpun2FUPj07s8bNa
3o44Up/r1SVeJlqsBLuB+KFnh8VC+B34ZPLIbhb1sD4qKkCFhvFsA/aniTSo77C9
dG9X45BuXdpfZ54Gt/6PRUxztZXVrEdB4nh4flsZP9/zqX4jqfYCP9s2TRNSbxfu
hFZCmWw1mSszJY6qjIhV6d5sQNeI0XN0lr7mBHmoTbXx0WrQpnK8yWUpP94NxEsB
5ePzOCXhGzQco9InOYJEvuTBPJcEPTczQN5SG1qSc64sShcBRoD56uKEoSdCrV56
La1epUKws6Ny5AiXgfMacvE7EWvdcB0UgWJqrTaHWNaPjTzJ+/9hnErN26OvJc9b
40tEgHdUMQYNKKRJe9iG
=648h
-----END PGP SIGNATURE-----

--E13BgyNx05feLLmH--
