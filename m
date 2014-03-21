Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984AbaCURpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:45:50 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44706 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaCURpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:45:47 -0400
Date: Fri, 21 Mar 2014 17:45:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-spi@vger.kernel.org,
        Wenyou Yang <wenyou.yang@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20140321174537.GC552@sirena.org.uk>
References: <532C6085.9070203@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
Content-Disposition: inline
In-Reply-To: <532C6085.9070203@infradead.org>
X-Cookie: Contents may settle during shipment.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: fix spi-atmel.c printk format warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 21, 2014 at 08:53:41AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>=20
> Fix printk format warning by using %p extension 'ad' for dma_addr_t.

Applied, thanks.  Please try to use subject lines matching the style for
the subsystem.

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTLHq9AAoJELSic+t+oim9b+8QAJMYskCpPnc47sJZOdUho0Kc
bJDlYHGghzz/1K+5GYxSvYB9fifnf1rVSxeHH3Rt0TovBtaelkeUaUJwk8S8vR4p
6VvP9bYDCT/CJWsulk7p8NYyqu94gi5CC0rDJUeJG82TkzmaercLFO5/mRuM8+H2
F/SpEdW51DgbKzEwg+GqcB7HimrXNqPKk4z2PPuz7N25amNO7nhdqK7U0Knzpwx3
Ygkrkt8MhtRLSg5CW5D85DKhek7hRClpm5MNDjuUoVSxcTpJJXbBQ/SYSCgNx+cG
Aehu+umXS+TGrIC5nrjL+WAYg2/Y04CnxLMPBvZGHXS+7uQiuDU0PW7U5LE7WfY0
KzH++EEX3CcQup0Z1t7PgtlMuPFsYV9AZC/hSlmNqLtnlTSUUOuQcCH7rE7yyI9Z
Ia6R/IDjwcASOk6syijDvtVdnR1jOTcz2XqSql6oVWcyB6Z2g9HFq8NitP66Ewos
5TxMiW6nJCG+9XDc7wHgmRGqHwUXxOJdt/SnPC7m4HJW1nrY4C5JXjyBEGC8ltFd
/Hft0gVl/OjjY463VG0P/1iP7TnmZEQC1hq29kgdpaP/P6eOhTg2kqiEDeFvqLni
urtSO+oKGLufy44yUKVjj7ijqpZs1xx1lr3sGi/KkoNl0HFG3UI7XlFSVERgPFmr
Qc69/U9h2rf81EUz+pdg
=VRFP
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
