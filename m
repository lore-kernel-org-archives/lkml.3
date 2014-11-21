Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaKUGqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:46:47 -0500
Received: from sauhun.de ([89.238.76.85]:48867 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaKUGqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:46:45 -0500
Date: Fri, 21 Nov 2014 07:48:06 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Alexander Kochetkov <al.kochet@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH] Fixes: 1d7afc9 i2c: omap: ack IRQ in parts
Message-ID: <20141121064806.GC1480@katana>
References: <1416242517-29885-1-git-send-email-al.kochet@gmail.com>
 <20141118163921.GB6179@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ghzN8eJ9Qlbqn3iT"
Content-Disposition: inline
In-Reply-To: <20141118163921.GB6179@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ghzN8eJ9Qlbqn3iT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > Tested on Beagleboard XM C.
> >=20
> > Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> > Cc: <stable@vger.kernel.org> # v3.7+
>=20
> This is good, but subject is wrong. That fixes line should not be the
> subject, it should be here after Cc :-)

I'll take this as an Ack unless you protest.


--ghzN8eJ9Qlbqn3iT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbuAmAAoJEBQN5MwUoCm2Q9EQAJgPLvW472Ir7iOkDZAMevMC
+FgMNp2moJfX8rWrkQ8nGnmcFsWRWlF3jjBWFkufsL0TcealeRAXsrHrnfXbm80w
C4HQiUOWq01+RWY6/aBiwHyBjO81fSP/3fquF+UpIUwyi9jtmybJ/883MeJVdaC/
GVJO68fEIcFEYT6CsQg7Tl4gicPWcfB/BmpUSHVRiff9P5usmjZOKVvUd2aaqpQB
6NLj1xRCLQol9DcbK48ItAPI0KbfRyNFXko3QeQudecnSxHrWOIft/MD98xWyUo5
RBL6r+F+NPRXqFWizDZPvATft1LZ8Q6HnspwZfJA2nwfvdQgj1pfgA7LMJIzzYvk
CBBeGxJTsEw7aHAl/jL2ckJBjhDxDSgIpyloGnQfqR3AGHbDZoScy3BLumkdLNr/
8yfDzmGlXJlXRIYIH2mRHve++62OsPd6BZe2yCknTyPGVgwRs/QW4LyTY1rFOzvE
3PW4S446/vOf4L8woxmu7Y3N4ig5W1Ba8wyBhMNUkcJBrH87tExJN+XY4zYLTzJR
aydAKp8sfT6iawinPUqm4BdxerSgM7mJmWWWM3pjhGH3HbtVSOtTcH/t62g5shFn
inyDQPPL45HUZ+ma0fVgfPmYR4LNWlFQ/4aBNDG8ZJNx2d33Rrrat3L9AVWht3GZ
mZbiiv5MNG5+arFFotcN
=Ecr3
-----END PGP SIGNATURE-----

--ghzN8eJ9Qlbqn3iT--
