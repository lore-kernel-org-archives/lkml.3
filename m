Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaKCSGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:06:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48008 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbaKCSGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:06:37 -0500
Date: Mon, 3 Nov 2014 12:06:02 -0600
From: Felipe Balbi <balbi@ti.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Felipe Balbi <balbi@ti.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        <grant.likely@linaro.org>, George Cherian <george.cherian@ti.com>
Subject: Re: [PATCH 1/4] extcon: gpio: Convert the driver to use gpio desc
 API's
Message-ID: <20141103180602.GU27425@saruman>
Reply-To: <balbi@ti.com>
References: <1415032350-8459-1-git-send-email-balbi@ti.com>
 <1415032350-8459-2-git-send-email-balbi@ti.com>
 <20141103180150.GA10164@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l/3WCmqZNZ+BnHMk"
Content-Disposition: inline
In-Reply-To: <20141103180150.GA10164@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--l/3WCmqZNZ+BnHMk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 10:01:50AM -0800, Guenter Roeck wrote:
> On Mon, Nov 03, 2014 at 10:32:27AM -0600, Felipe Balbi wrote:
> > From: George Cherian <george.cherian@ti.com>
> >=20
> > Convert the driver to use gpiod_* API's.
> >=20
> > Reviewed-by: Roger Quadros <rogerq@ti.com>
> > Signed-off-by: George Cherian <george.cherian@ti.com>
> > Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
>=20
> I think it might be useful and appropriate to explain that and why
> you remove support for active-low pins, instead of hiding it in a
> seemingly unrelated patch.

removed ? why removed ? gpio descs handle that for you, read the source
code.

--=20
balbi

--l/3WCmqZNZ+BnHMk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV8QKAAoJEIaOsuA1yqREwb8P/3iyJi7rgFgtJK2ZcXxZWFJ7
gv/yt0byPdY2C1tALT0kriVWlfZXP+YwHRXhLLQjeDPvyvn2VCVSx0ZPJYJzQJ7X
CKqkioFxifKDrPBA+r9w3dQgHgBN7W08DtVMNk7Tn/p6Vb2km4TLOfNDIu7vu+TK
A/xwkIeEh8FIrxw61/AqZqRHDrOfEcB0Y7XteaPuRPyitjBPprSStfNSWFBQjSW/
e2Uza9pbdPNvy+6heZKdrtsdAsfGyBBTOrcp96G6aZ+ooJVIPehDOJV9+OsAS7QM
iXk4IqwOVA/omKFE/u68jFlGUqiGYzcE/ZBApwmiGCALzFkSH5OyZlAQ2qTnlofV
EXjSx9oCgDnfaH7QM9Wo6ktC9wiOQfSTl9ttn0L4ksDMu1Bn0HecnDIijOK2leam
a1oJRlddbb1EVRr/CoQHWFdmI0MfHF9pgk2PJfoGsy3BmaRIo4YD73iqGuyc0fqa
UI1RxaKEn4scVe8Yy7q4ZJveSggbGQWMQjqH21yFwaLOob3kPcBv8rOfAbdOiF+6
W4Z03qVh6H2KlpLcgmNOmxr6b4GcVGJus2NXOe7tHmRulkIcow3mIeqxzG4nARMh
Dzfpd4Ps9C2pYBieUaQWWWEdAcgiHzRhQYhfSFIi1bAkKYsMtIjPpqOlbwRYIc9j
LrLhYkuIlyAywiSTM65s
=7vjF
-----END PGP SIGNATURE-----

--l/3WCmqZNZ+BnHMk--
