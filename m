Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaKCNzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:55:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41361 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbaKCNzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:55:08 -0500
Message-ID: <1415022894.27313.28.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 000/102] 3.2.64-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guillaume Nault <g.nault@alphalink.fr>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, Phil Jensen <pjensen@evernote.com>,
        akpm@linux-foundation.org
Date: Mon, 03 Nov 2014 13:54:54 +0000
In-Reply-To: <20141103103241.GA5511@alphalink.fr>
References: <lsq.1414880882.522510247@decadent.org.uk>
	 <20141103103241.GA5511@alphalink.fr>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UkqOtioBcyVf3Tc12aTh"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UkqOtioBcyVf3Tc12aTh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-11-03 at 11:32 +0100, Guillaume Nault wrote:
> On Sat, Nov 01, 2014 at 10:28:02PM +0000, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.64 release.
> > There are 102 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> You might want to add eed4d839 "l2tp: fix race while getting PMTU on
> PPP pseudo-wire". It fixes f34c4a35 ("l2tp: take PMTU from tunnel UDP
> socket") which reached linux-3.2.y under commit 109d10d1.
>=20
> The 3.16.y, 3.14.y, 3.12.y and 3.10.y trees already applied the fix.
> Other stable/longterm trees which backported f34c4a35, like
> linux-3.4.y, should condider applying this fix too.

Good point, I've now added that to the queue.

Ben.

--=20
Ben Hutchings
Power corrupts.  Absolute power is kind of neat.
                           - John Lehman, Secretary of the US Navy 1981-198=
7

--=-UkqOtioBcyVf3Tc12aTh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFeJNOe/yOyVhhEJAQqzaxAAz+AO2q9vjAFUgsjSQhMgANvw6TFyXhPa
aCWr2AzswKof+G2dB2vfoL5aj/KQdv3FJunk4/cL6q34SPtlB/NOoW2o/j+JjlHr
2VF8XzYtQs0uYg+va5ocGj8tLvxunkKFL2ToxleGP5KlA5tUhowYKhdrQYLBU+n1
2hsoWwnHOBPc62cgd0ZeBELk2iRgqNZRV6RokzZnpNO3RBPta+rjlyptq+j51vwv
1ZLSL8WGBxRV3LO03BaKv5pnGszYKsy1a/C8Mkd7Us1jVyKOOb0daA42Qbf0aPzu
rWTFTp6+TJ4YqLw6kTTAre5ClGwyLbjMPaRibyTUDLEbiHABKLAVb/Fm7cDUCBp0
JUzZ0frXWknj/zkyQ/1TeISTqtrsAyN/qxrmp2qUfz3wWM7O6TECv4wQsn08AF4x
5Sj8g6ZSE2qNLEd5POt7gREBCP3mPpD3YUPTuDYdnQLPpbvNuIUlwXvvtQtfACO5
4dD7bskE1iyQPKh4uemouaYbFXHx9I7+2r4YCAYMj/VRQBpe1GanP1pX01kO5lBZ
0/g/Z9mA2mGVVODhattixsWHQoXeas9JEvJPt/Gex5PXjkzZPluVhmOveT6SQf64
WSYFaZqhU9zK9sxBJcQuyOtJDsJG1JdxgkeUM7PQXMcZ7sSFA8tpdhoH3zIs8Q7Q
gKmpD9/mvNI=
=ac6g
-----END PGP SIGNATURE-----

--=-UkqOtioBcyVf3Tc12aTh--
