Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3BDXlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:41:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47426 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748Ab3BDXlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:41:42 -0500
Message-ID: <1360021291.4538.19.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 014/128] mwifiex: wakeup and stop multiple tx queues in
 net_device
From: Ben Hutchings <ben@decadent.org.uk>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Avinash Patil <patila@marvell.com>, Kiran Divekar <dkiran@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 05 Feb 2013 00:41:31 +0100
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D1432F5B8@SC-VEXCH1.marvell.com>
References: <20130203144644.035172954@decadent.org.uk>
	 <20130203144645.292616915@decadent.org.uk>
	 <477F20668A386D41ADCC57781B1F70430D1432F5B8@SC-VEXCH1.marvell.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-S9MyVAfHb4NBXSzA+2NP"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-S9MyVAfHb4NBXSzA+2NP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-02-04 at 11:43 -0800, Bing Zhao wrote:
> Hi Ben,
>=20
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Avinash Patil <patila@marvell.com>
> >=20
> > commit bbea3bc432dc5c08d09ca5c80afdd82515470688 upstream.
>=20
> This patch is not for stable kernel.
[...]

Right, I've managed to pick up 3 changes to mwifiex that it looks like I
shouldn't have included.  Firstly:

9c969d8ccb1e mwifiex: check wait_event_interruptible return value

This had "3.6+" to the left of <stable@vger.kernel.org>, whereas I
expect version qualifiers to be on the right.  So my import script just
put this in the queue without asking me to interpret the version
qualifier.  (I don't automate *that* because people use too wide a
variety of syntaxes.)

When trying to apply that, I found that it seemed to depend on these
two:

bbea3bc432dc mwifiex: wakeup and stop multiple tx queues in net_device
b7097eb75fa1 mwifiex: handle association failure case correctly

which also looked like they were important fixes.  Presumably I should
drop all of those?

Ben.

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-S9MyVAfHb4NBXSzA+2NP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAURBHK+e/yOyVhhEJAQrxJxAAttY03Gds6GDf6xZ+9gE7vkdqSlqB3FXv
5OU2tQHL7Im1gnsbfNiW7vz0r6vX8KrAvKwYjMSVQw+88iUQlNgTA2fD/FNUDOuH
UI+57qmmYrldpI0Pnuuk7Z0PTkumJnB+HqC0TpmJqm89RJYaPOad3ph6zo9K9tY+
f0drFj6atFrxWd6edxEqFz1VYjNAm8X3yGdZOLQQkqXIB08BAPowif9e2eOP7+QD
yi172DbFLzxAaslR86WK0aLp1yRho83gadsVjCyjzGccTzicEdVbAPXNTR0iH2Lg
Cm0JW4Z3uU23GPxqQIbaEXWeDp7mLPMHXXa8q+QbV/IQ5ByPzMO25K1aIvS//XLF
mYphOqAaDan3+Z1iVSXful1ZGWocOwaY3medKnGLCclqOqG5X3N5Bolm/gccre9Z
3SqXQ9VfTPqOdYuglRTQicRqzLCQwd0IHyIFRBBgcl2vtABWKiZ1o70RQ2YaN7DY
FfHqCALmRv+zBzSs0DtxSBfwLEXYXZ9riu0rXotAjI9ePtUTA1i+LCR3GBUCdG/9
CGauEkXvr2HeLfmHXq/rUt15YWTo4D5HmaJI4ep8hOSMAIAAQe9Dwg8eILO468YW
Pu3D0l4rraPk5FNh2RLHBzWPMqztcIuBU5K/iE7RGwbRZposUMSIVx/p4/8Vt2sA
HtArFIz3mXI=
=TNbt
-----END PGP SIGNATURE-----

--=-S9MyVAfHb4NBXSzA+2NP--
