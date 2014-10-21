Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbaJUOqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:46:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:41656 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702AbaJUOqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:46:21 -0400
Date: Tue, 21 Oct 2014 16:46:14 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] power: reset: at91-reset: fix power down register
Message-ID: <20141021144613.GB12944@earth.universe>
References: <1413829629-8705-1-git-send-email-alexandre.belloni@free-electrons.com>
 <54466B3A.5030005@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <54466B3A.5030005@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 21, 2014 at 04:18:34PM +0200, Nicolas Ferre wrote:
> On 20/10/2014 20:27, Alexandre Belloni :
> > In the case of at91sam9g45_restart(), the driver is writing
> > AT91_DDRSDRC_LPCB_POWER_DOWN to AT91_DDRSDRC_RTR, this should actually =
be
> > AT91_DDRSDRC_LPR.
> >=20
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>=20
> Absolutely:
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>=20
> If you don't mind Dmitry, I'll take this patch through the at91/arm-soc
> git trees in my next at91-3.18-fixes branch.

Acked-by: Sebastian Reichel <sre@kernel.org>

P.S.: Please update your MAINTAINERS file.

-- Sebastian

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJURnG1AAoJENju1/PIO/qalIsP/ikVMHzxiVzPJTBiDj9qNi4k
gombEl+CLdnshnPVYuqxysllTzhqRueTru/G4AByj4FIsLJqA9v9BQX3HRKc4D5Q
XgbgVgzVNyePmJMvBuIzXdpRkmY/VtieS2DJEHSphOQw+hIENjs5pEeekH2MKt5X
GduGatE6SXjYT0nL6EhtpwhDM6XoiTE26wo5PwxS6x+hCQTS7uwtxMDlaPGfVxvx
uzXZ11QxRng9cAFZ5UBGM89AB99wryOcqPsm5mJlnKQvM4++1eQm+f3fQBcUaFyQ
l3FAIUX1YtBoFcnZ1bVJMOoO+h6NUWf1ew2W/dRlE1yJDdh4l97adBpTsBjpu7ph
9FkNqockfaufPHR0uTPXtLir396SHDYrvD4UlqMh5cE4OtR4Ecu/QXvwsrKFJE5f
r1ioAP3Om9HDnOiMvfldcgs7Q1r2t4K9PQQzP3QE5y1mXmDMP/ouKTXwDyVb7rgG
ucXfOmdtar5TbbjNhGiyla/cuDHRrBYRChilMk80e3gtO1TsQW3ujQuiFpfMJk08
upuDtm+bxsV9N320QUZALfsQAEYGn3asQwJSMfZ6JD4ZyxbfKCYWFRRC808pKhuD
48vd3nH5oum/zLVcqjdpl7Ds/gFhFuBZe0oACZHaSMwlrZXswXiyr0/k71taIamq
toDngqAWE2ttFkQgorK0
=8YqU
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
