Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3IWHh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:37:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37249 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab3IWHhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:37:55 -0400
Message-ID: <523FEFCE.5070902@ti.com>
Date: Mon, 23 Sep 2013 10:37:50 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: <plagnioj@jcrosoft.com>, <archit@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 3/5] OMAPDSS: DISPC: Fix assignment of 0/1 to bool variables
References: <1379875453-20083-1-git-send-email-peter.senna@gmail.com> <1379875453-20083-3-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1379875453-20083-3-git-send-email-peter.senna@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="R6lCRfeNoXPtmMsBTBFi7eaiKNIJNAFaP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--R6lCRfeNoXPtmMsBTBFi7eaiKNIJNAFaP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 22/09/13 21:44, Peter Senna Tschudin wrote:
> Convert 0 to false and 1 to true when assigning values to bool
> variables. Inspired by commit 3db1cd5c05f35fb43eb134df6f321de4e63141f2.=

>=20
> The simplified semantic patch that find this problem is as
> follows (http://coccinelle.lip6.fr/):

Thanks, applied for 3.13. Although "fix" and "problem" are perhaps a bit
too strong words, as this is just a cosmetic change =3D).

 Tomi



--R6lCRfeNoXPtmMsBTBFi7eaiKNIJNAFaP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSP+/OAAoJEPo9qoy8lh71d2AQAJmLzUFRm+OPGDrjVwyN1S6d
vspi1WPsoqvKUySBWLH/q2UHo+e0DST1qozvd8A5vtlq1djvrj4g2HGb0ZoEKC4d
yKT91ll+XSPsWeCIK5yM64Xpgu107Jw0zBYYkEs8w5yXkKwrX0JODQCjLvQFBZ/C
BNnjjWMNaG4FjGI2u2S7na8w4jyXrdGrCG5ARFVqO7KQpjQ3khdQ1enMjKduAg+3
xKPlXN9C4S4fXT6C96IidQxQc9CM2hyLWKWfc1rCPFlbGqD5BVN7dQBbpsO59YX8
GSMzPYldCzVQGF9MtFoToUbnOj2iaf6JU9BAv+grkEMTZgI8cG/01H05exUA726S
jE5mxYJDXtBLaLQb9qJR3sR6JIBX2byqsB55tUwwZIqioMv2zRM5pYp6t3hKIQxB
Ca5NxEqWEZtkV/RY0TUzg08jPzajx+DuQs2uduGldAVcgnekcNGaBPq6/H3FJGgG
AAM/NC5Re+2EglwUYlOicbxcYA7Qd7LJkMRhJ9kVe6MpbBemkfZocQx8oveOBYL/
WGJ3wEJ6DYJlmfwmYedVxonbCepNkOypE7Fh2gjnHDL2XfycscHzriWoiWhm8clO
rITDNLo5o8qG7TbVc6XP4sSiPOVtOeiUprv+471jVedgWqQc3jSx5Ku8CGHkjMgw
oZyBA5uMrdJMJPYelF/3
=uidd
-----END PGP SIGNATURE-----

--R6lCRfeNoXPtmMsBTBFi7eaiKNIJNAFaP--
