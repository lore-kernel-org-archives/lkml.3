Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaJEVka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 17:40:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52764 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612AbaJEVkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 17:40:25 -0400
Message-ID: <1412545199.9794.21.camel@decadent.org.uk>
Subject: Re: [PATCH RESEND] x86: Reject x32 executables if x32 ABI not
 supported
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 05 Oct 2014 22:39:59 +0100
In-Reply-To: <alpine.DEB.2.11.1410052329160.4383@nanos>
References: <1410120305.6822.9.camel@decadent.org.uk>
	 <1412386843.9388.176.camel@decadent.org.uk>
	 <alpine.DEB.2.11.1410052329160.4383@nanos>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-aTydCRtHLkoF4WpbJNNy"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:4907:182:76d2:5e58
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aTydCRtHLkoF4WpbJNNy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2014-10-05 at 23:30 +0200, Thomas Gleixner wrote:
> On Sat, 4 Oct 2014, Ben Hutchings wrote:
>=20
> > Can one of you please respond to this patch?
>=20
> Oops. Slipped through the cracks. Picked it up. Shouldn't it be tagged
> for stable?

Right.  Please add:

Fixes: d1a797f388d6 ("x32: Handle process creation")
Cc: <stable@vger.kernel.org> # v3.4+

Ben.

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-aTydCRtHLkoF4WpbJNNy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVDG6u+e/yOyVhhEJAQrn9g//RtXg9PK+HY6Y7dD+3S2FYU9BWvIo07F4
p2toUALhv0cMfRPmlZ9wD7qFY8D+MCZ5PXpSEu0IXLqdaEdH6fE8PBFKelWdmkhk
QUSCVmBvK+i8LGOb1LXZhApRczp5As7ZcB2ROShGJxDSo/lMdxfIKlyq5O5AFZ3R
VQBqdkDikZ+ZRw/ifZCoaT8+7twL1gIMxlGj22FGYo769IV715viUdnU1wRxJG1b
i6/e8oJM3fYsV2892T1GjJWHs/RdEsHRgKbHc+QPOep58xf4SE9lAOCwA2hGri0v
N4dFO4h5pAalgwyy7U2eBYisSqmM/B93yJ36m+f5pCQF98oKLHXIat1wBB9vJs0F
jXA08BXkaUKUcEjJTdixsJSAyoUyJHDFlPe3dKrQJ2SYVMsZ0ww+e7Eb3d+CQvK+
iMVRBRwWvROUbVP2GYKyH4KpKZpWwiWsrzQbAjusayfwH1uhKJpZzsingi4dfZQ1
m2c2QEIY5IfBSyZOtT/VxhxOEE84AIlHqt3j74At9hwsS1ecNpfKoTGvBIgUbcFy
ZkHHlbXvZdHEXJAWPr3z5cqDo3A1JvVEJkuWjOwcyELczxoM+el2FG1DkN0qKSTD
myGo6GDGwG+mBN1Fk8Kc5YjXvA6fC1yWgK0hpt9mnnkQVhxd861cNyZ53cOn43xg
b/vOkbi8GlQ=
=aPkR
-----END PGP SIGNATURE-----

--=-aTydCRtHLkoF4WpbJNNy--
