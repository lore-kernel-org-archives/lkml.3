Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaEZSSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:18:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43550 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaEZSSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:18:07 -0400
Date: Mon, 26 May 2014 19:17:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dev@linux-sunxi.org
Message-ID: <20140526181734.GI12304@sirena.org.uk>
References: <1401116292-24066-1-git-send-email-boris.brezillon@free-electrons.com>
 <1401116292-24066-6-git-send-email-boris.brezillon@free-electrons.com>
 <20140526154356.GZ22111@sirena.org.uk>
 <53837298.5080705@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1qf272Yl6F6ZOP94"
Content-Disposition: inline
In-Reply-To: <53837298.5080705@free-electrons.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 5/5] regulator: axp20x: resolve self dependency issue
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1qf272Yl6F6ZOP94
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 26, 2014 at 06:58:00PM +0200, Boris BREZILLON wrote:

> AFAIU, we could factorize it by the mean of an helper function (say
> devm_regulators_register), which would take a matches table and a
> regulator desc table and do pretty much what I'm doing in this patch.

> Is that what you had in mind ?

Yes.

--1qf272Yl6F6ZOP94
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg4U6AAoJELSic+t+oim99XoP/3Tx09VAgYa5h+tPZLIXRYdX
FMs3sD6++FYZiuQnWcuLSE0gITcQpdXnlxBxT9mh7MyPxk4PK3ezXvKmKlBkPQ+l
Xdb0jdVT+atJOPOECP3wFe34YrjcyssOakSuq/6Hz86qQO7kKy5GCATCp8SN64VU
0lsxfkvcndff0MHbMn/IrQzv1l2ND2EO1/lwdYHqE5uNe62VHhU9qOqxlmXPggFM
L8fUJZuhFKh4ImlnHcHWoz6Cl1poGKjljm26MEIfEv9X3PHLdSIyaLWsvbVTZJFj
GVe8dg7tiNab7fXRVYgxJEyaBmVwZNj0yhCSfpzQyJXcaj/58/52f//7wu0Ia8g8
eG7sd9VPq7GEuKNcXn4urrwEZC65/OBwgZf3G7qK/m+srGGlW6NEDINhhNrROLNb
K1FConFS0PJd4qf5OSe9nMEI6m76vJRxIAqSWqR3H1IG7XUl9E/ZJDEZXSA8uW3s
PO6If6rhxMCxN0VdP/YNjPCUfuiClen24m/5aLX4JG6eMqdo2BMR/XJ8ciQA7vFi
lHHKJvSJnWquvWOoz5TvjY2l6rOMtyWYQvQke9pKhsMhAcdAgSOsMNUCEDFDQDab
7OS36p8ZYSWS3H8CLPIHA4cWflB26lwl4avf3cMovhRQvR672x85/+lcWfcCl9r7
7j7wPIn+ioMT49afGfDL
=8gwE
-----END PGP SIGNATURE-----

--1qf272Yl6F6ZOP94--
