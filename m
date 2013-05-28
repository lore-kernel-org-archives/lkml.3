Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab3E1CDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 22:03:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52155 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758539Ab3E1CDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 22:03:18 -0400
Message-ID: <1369706594.3469.415.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.9-stable ]drbd: fix for deadlock when using automatic
 split-brain-recovery
From: Ben Hutchings <ben@decadent.org.uk>
To: "'Lars Ellenberg'" <lars.ellenberg@linbit.com>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "'Philipp Reisner'" <philipp.reisner@linbit.com>
Date: Tue, 28 May 2013 03:03:14 +0100
In-Reply-To: <20130514132510.GH21623@soda.linbit>
References: <003801ce4c41$d52a0890$7f7e19b0$%choi@samsung.com>
	 <20130514125655.GG5196@hercules> <20130514132510.GH21623@soda.linbit>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Qis4TKbZFNEocQKZNyvI"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Qis4TKbZFNEocQKZNyvI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-05-14 at 15:25 +0200, 'Lars Ellenberg' wrote:
> On Tue, May 14, 2013 at 01:56:55PM +0100, Luis Henriques wrote:
> > On Thu, May 09, 2013 at 08:14:47AM +0900, Jonghwan Choi wrote:
> > > This patch looks like it should be in the 3.9-stable tree, should we =
apply
> > > it?
> >=20
> > This seems to be applicable to older kernels as well (starting with
> > 3.0 at least).
>=20
> Ack.
[...]

Queued up for 3.2.  Thanks all.

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-Qis4TKbZFNEocQKZNyvI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUaQQY+e/yOyVhhEJAQq1Wg//YrftOokyFVhZKqQixTUTD+FYZyl2hFRu
+HeAmvFNIAzhzPj6ioTg+rV9YFc1wZzsHEYWWgRewBCGP2OFZ78Xl77jdH43J06m
oSGOc4GryJ1PNoU+rlOD8kk9r3J/KodDbCUmQHWBvZiF4OOgL9tBM98fTPB3FOX7
Q4UirAZtE5hfSWQ0SpYZsHadEzG6ljoMJ/RSaEGoymo7jll9FepWAyYUlpavARr8
/o40R0e/9KsrOiF+sZ8dJvBuRND2uEjp4I1dMiFfM5mU22D9otGU6/HU+mAtd/NB
37OIYPCGZF2iyFhCNSPAhAbRN5Q4rq4KtjdWAIHaGw511sLtfh78CNtoHKu98lOJ
ybSe0Gt2m3g6WcCEZneNg7A22uF4UxHzqG1xzE47He6UzBRRP+kThlpREZ9pwHly
MINvQmS6qCaPkjjusVNOkBrZufI+DsOxEcI/20ZhXrnGEtseUx9Sdzj0MwCW5jSX
mVqxagwy0APxPMMB1PM/uVDwngidK9fV13O8sJVJGZyr7NmGrxUIosRdYTw+rrBk
72/vIa9inwtllGrQ+UtAAeEvbKNYZmzeZpvI4aXRNJTK3ThJhvGWEceRPhlJzqp8
XPV5hSMCVWv3c1dAz4qDW8FH5wJKCjSFh6j6h6WtJ+k+SAzjvT4LC6KCtMzM3+ix
IkzP6G/+Y5Y=
=ocH2
-----END PGP SIGNATURE-----

--=-Qis4TKbZFNEocQKZNyvI--
