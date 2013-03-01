Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab3CAH6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:58:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43425 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709Ab3CAH57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:57:59 -0500
Date: Fri, 1 Mar 2013 15:57:27 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH] regulators: max8998.c: use dev_err() instead of printk()
Message-ID: <20130301075724.GN25302@opensource.wolfsonmicro.com>
References: <1361591555-12729-1-git-send-email-tfarina@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+cfQkLQGU7KOA/8T"
Content-Disposition: inline
In-Reply-To: <1361591555-12729-1-git-send-email-tfarina@chromium.org>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+cfQkLQGU7KOA/8T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 23, 2013 at 12:52:35AM -0300, Thiago Farina wrote:
> Fixes the following checkpatch warning:
>=20
> WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(=
=2E..  to printk(KERN_ERR ...

Applied, thanks (and discarded the previous version as it's subsumed in
there).

--+cfQkLQGU7KOA/8T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMF9dAAoJELSic+t+oim9cgAP/jQvfi91SDYVP1rrT6rPPLkS
t1z7bvJQ2D3bqsyIclHuIgMoX42A0/BXAm6SEFgzg/qkoHiHxS/BhPoxz/t6mMQv
3nfUrzDe+GrJrgirRI64UsEjdVVsCtW5C546COZqScGC638dZnC9iBrYBS7Oo3o+
BhWnTKN0EvXN5v6ape3MFlnOfLdZ5T6c30dxQEOlTcMDeLtj1AO3OVu8L1ntHvsn
kRAKCpA7N/Gumx+8B/jNKinxgiI4KmY91Sg+aBvRMcHPyWw5TVN/CzPEdBrqLDFJ
BVf7sPSldgRBniqGWYFVZEIg9xga7EzqdisbeJoRruuPzWcWtevHkbupAM7u6SmZ
Ol94cWu4mdaeuYFPi4xbFVzTl6gxrWXrgO451ByMRWVI8hVz2zYa9sEdpfXYWhkc
JZE32mUpHTTHBPxcAAzzP1vL4IKpY8lKXIbMrh+6C0PfOsSGuHlFVs/6M3Uy6Pxc
qijktB9fd9JzCVC8G7lsc72BfakWS7ujM1zjnbfJpizGRK4h3pbig15edqVlsxK9
6tKt7wop3DuzyLBEGC7N0BeHEUoXo7cj7A7YXf/wJPdPF/VkNVW/PleR+Y6SM8An
xY/+5z8a5rAmqHWrS0subrISzApMSqfKwyQ7LRdaDfo/eYg8GtEN5QBqV6UfL+Bw
SoR5Sw16ZVJNV/jK5s+F
=HwhL
-----END PGP SIGNATURE-----

--+cfQkLQGU7KOA/8T--
