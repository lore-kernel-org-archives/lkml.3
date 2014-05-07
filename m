Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaEGWFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:05:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34264 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752618AbaEGWFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:05:12 -0400
Date: Wed, 7 May 2014 17:03:17 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 5/7] usb: ohci-platform: Enable optional use of reset
 controller
Message-ID: <20140507220317.GD7047@lukather>
References: <1399434623-20383-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399434623-20383-6-git-send-email-maxime.ripard@free-electrons.com>
 <536A5EBF.10309@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bjuZg6miEcdLYP6q"
Content-Disposition: inline
In-Reply-To: <536A5EBF.10309@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bjuZg6miEcdLYP6q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 08:26:39PM +0400, Sergei Shtylyov wrote:
> Hello.
>=20
> On 07-05-2014 7:50, Maxime Ripard wrote:
>=20
> >The OHCI controllers used in the Allwinner A31 are asserted in reset usi=
ng a
>=20
>    s/asserted/powered up/?

No. There's an external reset controller that maintains these devices
into reset. It's not only a power on thing, it can also be put back
into reset later in the life of the system.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--bjuZg6miEcdLYP6q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTaq2lAAoJEBx+YmzsjxAgXB4P/isSlQDDm1vHCwWaGZtawfbH
nxnGLvzlpbPSnccEx4q0yI/PCgpEywxbs5zOw/qw7YLSmZwgkEiWQvhYvZAuR51n
WUHwH77muuGAXfZERA+rNZh3fZIs1Q17LRT4bPonEwryQm5cOIFgCTyqRQ5Ye7li
g18AffA/hargu7ZBcEC9HCDQbU6uDfsV6RE9N75l13PFG0EchZVj/WfL90hpzH8I
SFqfKnRoPdejujWPKG+6W0s0BXHqeQskzpZNulfGn37katNcMPRYnE2JU4SuF9Qg
9BuOPDfLc5jeZ8J0YkbYs8o9wv3JeY/XZwWQ4lheP2uFEVuFKJjjuBxPniHoUFYR
pFqkT8/ADhFsMvO4YyL3V8D5m00sUw80VC/PFl89dqROyPnZK/CPUu+ZFmczxlqB
9qhfBahI9WSUq56EVVineDJTYNhJG9M6JWLw6oUyEdaDny2QYqKAs8ut7UpgoA3/
e8j+xGvneWd8l0QEu8yVaKbwU/MNhwVRy7AVwHmLekxXW5wFNWQmuYBxHG+8Z74c
yvJe/fXADrLypJ+0AoEj7CRElvvhhi3AVm+OfpJss1lj04rTVPN4zh0E5UlHWuj4
tEAd0Xr1FrC5EKJRGk3aAuntC48oLHIEWjq1PmZhCEgFiygTmAYrHWILJJD5bDTV
jtV77uNZdnGjcis4qOUl
=TGas
-----END PGP SIGNATURE-----

--bjuZg6miEcdLYP6q--
