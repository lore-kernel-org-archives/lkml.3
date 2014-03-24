Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaCXNeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 09:34:07 -0400
Received: from sauhun.de ([89.238.76.85]:46852 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbaCXNeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 09:34:04 -0400
Date: Mon, 24 Mar 2014 14:33:50 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH] i2c: mv64xxx: Fix compilation breakage
Message-ID: <20140324133349.GA2631@katana>
References: <1394204370-22979-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140307160836.GM21483@n2100.arm.linux.org.uk>
 <20140310105808.GE2815@lukather>
 <20140310112929.GY21483@n2100.arm.linux.org.uk>
 <CAP=VYLqCmG6fRmPPABoW4xg_tFgGh2pji=f5ML=cBgCu4zZocg@mail.gmail.com>
 <20140321191739.GT27873@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20140321191739.GT27873@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Looping linux-next into the CC since this is the cause of the failure
> > in orion5x_defconfig there, and no point in anyone else re-doing the
> > same bisect.
>=20
> I sent a fix for this that hasn't been picked up yet:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-March/239069.h=
tml
>=20
> IIRC, Wolfram's away until Monday, so I guess it will be merged some
> time next week.

I'd love to apply the fix but the reset framework update is not in
linux-next yet.


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTMDQ9AAoJEBQN5MwUoCm2qLkP/jAS+vrwUic637j9sFZvvS5Z
j231DVkCrcJeIxwHeytyty4DS4G3E5/LDl/keqKB050My8XPmyGRWBHaJBwQ1/jR
TsQLnj6vofIesPu2yS/MRPLKFIwpPJFAl4FtL84aoPUeTDEf1ibBqg3jEbniwxHX
j/+XtCmg0176wJt8PbP5RdwVOSZplmC3l6aOyJDnJTqr13YlJ8QBNQejW40B63Nl
xcenvr98ta7l5tLj3EOx5cAKAGyesFe5Ig/erNr8tY/0bl3a1WqMDOX5VZqyA0jf
CoRsw0YkaUKX1ncKX7116eIFQIy49kOx7VA7SjRMGuZ9W4/aPtXnb2eYT4ij5/Lo
6QkxLYCLrurzMehA6Ab/532MMP6sWdaqTHmNUTySFRcyKhouqbLdhAWOLpVQzR1i
b/WdEJO2dbNtNa/UCIYmhWByp0RM9mAfr/MyXH1ljOxdXQfkvO+p0ruWpIv8TLfc
FU6VAx8BfUOe6ReduTlCrxo10sxxHpTPvHHZIMpH9In+gyJpThgjkgnKSOPrx315
VMYJ5/mhUDzDe+NnJN8Kl6q7f5DKu0pQ7SRmmH/gf5DcUwZO3lOUXMxkas3RsCGv
KZruLp8/0uSp23k6HmEgRLZb0Equ12dJ+baBoRUJ3X/xbcMR3ZtK6MjTnKF/qXK3
jwBhbL3sNWUkJE0tnPLx
=eKIF
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
