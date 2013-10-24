Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab3JXJLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:11:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56983 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab3JXJLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:11:22 -0400
Date: Thu, 24 Oct 2013 10:11:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Michael Grzeschik <mgr@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131024091115.GF31415@sirena.org.uk>
References: <1381916039.17491.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QNDPHrPUIc00TOLW"
Content-Disposition: inline
In-Reply-To: <1381916039.17491.1.camel@phoenix>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.186.44
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Revert "regulator: da9052: Use apply_[reg|bit] with
 regmap based voltage_sel operations"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QNDPHrPUIc00TOLW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 05:33:59PM +0800, Axel Lin wrote:
> This reverts commit 68f7506017ba67f1334cf086ffab76606f2c5ac4.
>=20
> Michael reported that with this patch we loose the fix_io code path from
> da9052_reg_update. Thus revert it.

Applied, thanks.

--QNDPHrPUIc00TOLW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSaOQwAAoJELSic+t+oim9dygP/13r9GGKSbtS0WbiUjXmWmUX
jO1gBMN1twUyeewtx4sB9ZIcXMTJL1et1Efgqs3y2kf2f3O8AqUeE6+ke4x0+U95
ffpfd2/dOT724lAfkYeE19vK8TxF4lA3zsgLsfhf8S01QDx6lLuAIC2JTDk6I//K
mM8sfnGIi5PAw3qOQ16pnGhrSi9bnIQUCCUO5r8jwaVuh7PC4sEOzUzmIEy8IS71
1zQjTEw+UZjTYpNoi1yMxTpzyr9gQ+973tDwaV4pwoz7oBi8UY7uk0JryBxrxEc4
esBS1iHhC2w9hnUQD7KQnmR7B1BU8qHQhODNDFbm++CfO0lLi417viJNa9nuWXt7
FGKqfLK57akxfk1251jLwHcAhHtZarS3aiDHxnNX1CIQmxxqBV0+XlSYGN3PpgY+
i5bC+HmupOPPDngmdli0Pg29uYpmoKtiotDpsRcLJepIowHnSXbG5qD0Ebt7BE79
cGOeZR6diRxPJN3FK5wSM/uCoFCcbpzMLgFHLTtuhM+wCgmnZkRDWesYnZ/vRzHD
80wFq4cN5iziGbSUu9sdX8o0CY9p824gAARhUKqnNxbp/HJO7dIbUID6BKLcySiC
U5ml/DQm2cnwTLXHMBF7hahCiF2tYVjVh+7/yu+4fd65Ulcbai1VXMnUtSXPkTZJ
xMWMfimTmm6ffq3jmw5n
=vLdQ
-----END PGP SIGNATURE-----

--QNDPHrPUIc00TOLW--
