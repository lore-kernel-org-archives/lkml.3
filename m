Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3KSP44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:56:56 -0500
Received: from sauhun.de ([89.238.76.85]:52913 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab3KSP4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:56:55 -0500
Date: Tue, 19 Nov 2013 16:56:46 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PULL REQUEST] i2c for 3.13
Message-ID: <20131119155646.GA2569@katana>
References: <20131118193802.GA14925@katana>
 <CA+55aFxZaC=beR+dN36Sv==6fjY7SdOdwXaSHU+wnk+-oDJp4g@mail.gmail.com>
 <3690707.5664qBQcL8@vostro.rjw.lan>
 <20131119150001.GM2281@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20131119150001.GM2281@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Actually, can we remove the whole clientdata setting there?
>=20
> Commit 0998d0631001 (device-core: Ensure drvdata =3D NULL when no driver =
is
> bound) modified the driver core to always clear out that field. Same seems
> to apply if driver probe fails.

Oh, nice, missed that commit. That indeed should help cleaning up the i2c
core a little. I will prepare something.


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSi4o+AAoJEBQN5MwUoCm2dDIQAJJAuFfAzmhcYrK1Ns8Y/K3y
BhiBkbqdOKoyAVbdSCiqO7kNDGO+nVp+V9TiELLuJg3d74D4Sq7Ml9qRbIhWiH6E
APoRjmgYC+c4XZ9/o57SGPmcBoFckx1KZaT9AI/W9/lL6FAnKIgrDLDcrwZOV4+V
/F9OIbXKaDkDsIkDhPw7Yj89WGNKy+LAIlngUKLl6bYfq+Xa5Ympfr13z25qbh+y
zZ9A5bM3ruImEAkdqtSH/d7Yop5LlRLDmwrGOZt620r/OYjJzfYbsvESCagetxrX
uA0wrufem5shuON4zem8FgEHitnCzX8StkxZvGLWtUBOxNsnny+EV1uYWWpLCYdH
pTaDCRdH0C7jVlAy9sLP96KAQDVCcTW3M5QKBevEs5NVom71P2oIufAwcuef5JTK
t+oPuco1W2E0UNmaDh8CZmrXmtrS9WadUd1ubuTpkRrJhB4ec0cq/N03WCADapsg
CjUZsm6+ve4osvVMmdPrkdcKBm2mjDSaY3V4m2LhgYSfijwzweklSMJgtejx2B7I
7thHRh54xJ4btmq+HEDRck3t4ZKcMn77zp/ofdwqPIjuO29ub6VtM25M/8MCqLmc
pZ0mwDXTiwjpIzSXEm0unpWrXzYuB3vWBfkwC5t2Iqmeegu6sBhmheTJ99xpxgXf
0iMZf+Wis0ru1uhypHRh
=aeJ0
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
