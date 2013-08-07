Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab3HGU2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:28:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48088 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932980Ab3HGU2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:28:35 -0400
Message-ID: <1375907298.27403.35.camel@deadeye.wl.decadent.org.uk>
Subject: PREEMPT_RT vs bcache
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Date: Wed, 07 Aug 2013 22:28:18 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-CHjdyhjP3ZTgcDXfbsSf"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 80.83.48.229
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CHjdyhjP3ZTgcDXfbsSf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As Kent said back in 2011 (commit 84759c6d18c5), bcache needs
{down,up}_read_non_owner().  But these are not implemented by the -rt
patchset when PREEMPT_RT_FULL is enabled.  Can they be added, or is
there a fundamental conflict here?

Ben.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-CHjdyhjP3ZTgcDXfbsSf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUgKt4ue/yOyVhhEJAQquaQ/6A4y0KMC4QFOzJhf88or4d91UC4PGD0lc
h9VPOqfQkMHz1uVCwxpqmuzWiSe/qRtehujY14QdlPVuNfomLpi1Fl9n53mWDxfV
iPwdFZ5UF/Om+cG92txXv5HxOeUPNOXwmPGr/x6UO91bsz9BWfD7C7Dutk1MC/9g
BUZ6gyEmw5/t5UulFEEo9/Xk9XJvfZOAxB8aIY2L4dyVvdxnUktxMWu5qGy/XV/l
+iG+QTHi7EBRBoI9NCHaVC0T+lR2jZVJzi2CSS3tvqEoGWIfzb0FNSGSCaXsTOsE
aPo2OCaPhYHylMDcfvk3R2+t9WUlEHg2AMeeDK5wZkC/goQMBIrgjhZxmt31p7k0
uW49VnjSIlwt0WPzg+v9vH/l2L87gSB2Y29uzh3B3Sa4L2xe+rN4vwwt24U1OaRi
JNwntFKCMYz6uivd01HoLgNZWsqVHmNsqugHkTgKpUmnPd4rrJeBqEZ9CyfhaIrC
phuouPYDonmfriqimB9nfPeGIhsnkEQa/iDqLlqDh4F6VNMxDbaB3nRgCbJHoK14
BLxr2VMXqKssfBZQEimMrofkN1OBaiIDsdPADqY6SPHbVJNxYNfUiWboxwj0XZED
L1UBNTZLrnS5afjF/QLTisy9rt/7ZV0QVRuOdjcCJU4FLpveYPCzx7WrDMxCeA1X
RztxKZp+Waw=
=/HCe
-----END PGP SIGNATURE-----

--=-CHjdyhjP3ZTgcDXfbsSf--
