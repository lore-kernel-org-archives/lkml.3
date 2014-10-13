Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaJMNK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:10:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50669 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbaJMNJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:09:38 -0400
Date: Mon, 13 Oct 2014 15:09:18 +0200
From: Mark Brown <broonie@kernel.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Message-ID: <20141013130918.GY27755@sirena.org.uk>
References: <1412840528-31508-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ds4tGy7aNC8MgBu"
Content-Disposition: inline
In-Reply-To: <1412840528-31508-1-git-send-email-kiran.padwal@smartplayin.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] spi: qup: Remove .owner field for driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4ds4tGy7aNC8MgBu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 01:12:08PM +0530, Kiran Padwal wrote:
> There is no need to init .owner field.
>=20
> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
> "mmc: remove .owner field for drivers using module_platform_driver"
>=20
> This patch removes the superfluous .owner field for drivers which
> use the module_platform_driver API, as this is overridden in
> platform_driver_register anyway."

Two problems:
 - I'm missing patches 1 and 2.
 - This only changes one driver but essentially every SPI driver
   initializes .owner - why is only thi sone driver being changed?

--4ds4tGy7aNC8MgBu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO87+AAoJECTWi3JdVIfQY/0H/ipMeDskAN3b1Vu78Cz3GC+3
Xk87d/mOAOT7o3ogH4PYH5aY6SxWXX0kGFHL5NGM4JZXV/CtkaxnOzR5pc1M/Nbk
Q6hqFd3+qRmkxhBFaQ0K3oekJtUKWST4jQq/d3fkiHcJ1bM7zs3NG/hxsZJvEHW4
rml1x/aQ3WyGADy4GghfjkYTPVBSPeAzpCqWqzvN7s3DmqH66ezdeJO0i9yEM5a+
6/LjQ0+Ljca2XfcTrF10QHyLBMWIq+egq8QA7NTDQrMLfMi7PJlyP0ek2//mevvB
fFvK9VbbzOpSd2oihLm4rpZAGM1v6AO5JVGtvtPIvkYWAqgrMngLO4HGbv5r5SA=
=HnE7
-----END PGP SIGNATURE-----

--4ds4tGy7aNC8MgBu--
