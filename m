Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaLWRes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 12:34:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45869 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaLWRer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 12:34:47 -0500
Date: Tue, 23 Dec 2014 17:34:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-spi@vger.kernel.org, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Martin Oldfield <m@mjoldfield.com>, linux-kernel@vger.kernel.org
Message-ID: <20141223173405.GP17800@sirena.org.uk>
References: <1417425166-150374-1-git-send-email-mika.westerberg@linux.intel.com>
 <20141223134917.GI1314@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lqu5hkAdORZH7CMT"
Content-Disposition: inline
In-Reply-To: <20141223134917.GI1314@lahna.fi.intel.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/pxa2xx: Clear cur_chip pointer before starting next
 message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lqu5hkAdORZH7CMT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 23, 2014 at 03:49:17PM +0200, Mika Westerberg wrote:

> Mark, any comments on this?

Please don't send contentless pings, they just add more e-mail.  Resend
if you think something has been lost.

--Lqu5hkAdORZH7CMT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmaeHAAoJECTWi3JdVIfQftkH/i96nI4/ap+h67Q2bN7vZthH
cxe59ZLMjYkLMytRrnz+SNyXzqS0A1MFrHNRhXX4IQLEYUp39qcZ+fX5XK6av4b3
JlqzzwRgT4xZEhg/P/3JvGfs/UCtKrnk2gM7g1bJpM5paNwyVJxuTP+CCGmyjUIe
CuXW0ZlloWPk3md2JEMtMWvRWjc9yBetQrVkpPvZbyhC9viisCPn+tASoqtkwnSI
9WrajBORnGI9p2PXJPFq+OkuX0e+wCef04rpL8PQYXOm0WchIOV/8QVvr7JcMTRJ
FxoHSe4RQ85gIlnyB/8SJobGYJu7E/H08b1RiQDf//qqdh6YTVc3vQUbP0OvJK8=
=YVbY
-----END PGP SIGNATURE-----

--Lqu5hkAdORZH7CMT--
