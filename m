Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaKCMKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:10:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35238 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaKCMKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:10:45 -0500
Date: Mon, 3 Nov 2014 12:09:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141103120919.GE3815@sirena.org.uk>
References: <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl>
 <1414668415-597-1-git-send-email-mike.looijmans@topic.nl>
 <20141030165133.GB18557@sirena.org.uk>
 <54573860.4060708@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brEuL7wsLY8+TuWz"
Content-Disposition: inline
In-Reply-To: <54573860.4060708@topic.nl>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] Add ltc3562 voltage regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--brEuL7wsLY8+TuWz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 09:10:08AM +0100, Mike Looijmans wrote:
> =EF=BB=BFOn 10/30/2014 05:51 PM, Mark Brown wrote:

> >>+		np_child =3D of_get_child_by_name(np_regulators,
> >>+			ltc3562_regulators[i].name);
> >>+		if (np_child =3D=3D NULL) {

> >Use the core support for looking up constraints please - set
> >regulators_node and so on.

> I've been reworking the driver, but this is the only feedback comment I
> didn't quite understand. What is it that I'm expected to do here? Probably
> just the name of the method I'm supposed to call here would be enough.

No function calls, just use regulators_node.  What is unclear about the
functionality?

--brEuL7wsLY8+TuWz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV3BvAAoJECTWi3JdVIfQgSgH/3Ts5RvuL5oWyH5a1sCSabe+
ogSsV48uKOVpburP/lRXkKCAJxHQL9u2t0W5JiwKgGGfbRknkzMi02mqVlRH+wz0
I+ZcGQ9r+klZVNJw9yw0OUZDSLJRpo+Yy2xh+ED7SdvHEoVx14S/9vdHFKW53l0T
AGd28gfU8fvp4EI2ptIG84+gS9CWk+t2O5wNUKqfrP2Qs9U1vnHYjbjDF6dyIg19
NSc7aedcLgM/ym9ajCQ+vB3c+M1/bpoicYRk4RUd26JQiW6iWxPzEx18DpHl4OO+
Kp4oleqpAw7PqCNabnsfdttmSF4EAtUb/hAVyTIMFvLIxw3vjb5VFRwYV781wUg=
=GwIC
-----END PGP SIGNATURE-----

--brEuL7wsLY8+TuWz--
