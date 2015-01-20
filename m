Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbbATQGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:06:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43261 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876AbbATQGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:06:14 -0500
Message-ID: <1421769966.31046.195.camel@decadent.org.uk>
Subject: Re: [PATCH][v3.2] Revert: x86, 64bit, mm: Mark data/bss/brk to nx
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 20 Jan 2015 16:06:06 +0000
In-Reply-To: <20150119171902.3877f9ee@gandalf.local.home>
References: <20150119164926.168e8101@gandalf.local.home>
	 <1421705231.31046.191.camel@decadent.org.uk>
	 <20150119171902.3877f9ee@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fRPCAlR0TAXRcbFEzoma"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fRPCAlR0TAXRcbFEzoma
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-01-19 at 17:19 -0500, Steven Rostedt wrote:
> On Mon, 19 Jan 2015 22:07:11 +0000
> Ben Hutchings <ben@decadent.org.uk> wrote:
> =20
> > Yes, I know this needs fixing.  It also broke suspend/resume on SMP
> > machines since that involves offlining and onlining CPUs 1-n.
>=20
> OK, as long as you know. Also, have you seen my other patch?
>=20
> http://marc.info/?l=3Dlinux-kernel&m=3D142150909924885

Yes, I saw that and have filed it away for whenever I start working on
the next 3.2 release.

Ben.

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-fRPCAlR0TAXRcbFEzoma
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVL587ue/yOyVhhEJAQqKNw//Xg00kSXhHvUm8prp0+cLloezmjUZBzLp
fVnLI7CWMyRbqTZfglDC1f/OIIbx5ufkoVahiPOFOPHCS5m9HYt2dUj7paB/z/c6
wukdh4H83HG7R6DSD5M3pjS72JM4uUk89+wav3SoqULFRIaoNFXdsjApd++JAgcD
/Yvo4h6Hs8GtkelyzwqQuFulWtRP3evDqXkxcvhkCpYd+/L5FRSwMAgXrTA0n6jl
jWgMcpWF+pYdG60sXtAix+ZaaHoOdj7PUuSNGrvSTFJvnCDacSWdAhS51ZbkOp43
EkPlhbRFjXJIuicQbXcR4LU6Izch7KJsEsPHaMZHoPbqF45Hs1uz9gXmP0XVb93K
sGHoSiuofrFKaiYOmbw9mJbZU+cqpT3y5k1U+5Go8TESeLuGoofjs+KFna3IjBZJ
+87dTTHjiYuGnGcJ9GPKgO+6AHhtxwGY/5BGmevs+CNOo+oYA2sQ4LTB/u4g1a3d
WZygCOju34uuasqq5gQYDASbPUMJrXpkpgcgsqHEd8+7VX9CiMIAfYyVBJCmko0i
VyDNH138Qkyh7fNmCvdk466QdRcSeNDJE9NWGAKjTTZDsr+kiHsp7wmvFmLgJKR0
cP3L46JWP7rvgAP7MU5fQQFMimQuuw7P8yOmPicFU9Mhcwltl4+HIql1HlQDIPAo
8kn3lBq7Z/8=
=QKaD
-----END PGP SIGNATURE-----

--=-fRPCAlR0TAXRcbFEzoma--
