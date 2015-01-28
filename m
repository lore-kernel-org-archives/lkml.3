Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbbA1UNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:13:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57184 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbbA1UNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:13:37 -0500
Date: Wed, 28 Jan 2015 21:13:33 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Paul Clements <Paul.Clements@steeleye.com>,
        nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Nbd] [PATCH v2] nbd: fix possible memory leak
Message-ID: <20150128201333.GC27422@pengutronix.de>
References: <1422362302-25252-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Content-Disposition: inline
In-Reply-To: <1422362302-25252-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:12:41 up 7 days, 10:19, 26 users,  load average: 0.31, 0.40, 0.79
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2015 at 06:08:22PM +0530, Sudip Mukherjee wrote:
> we have already allocated memory for nbd_dev, but we were not
> releasing that memory and just returning the error value.
>=20
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

Thanks, applied.

Regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUyULtAAoJEEpcgKtcEGQQws8QALE1ukhsiTPCTtMWhW7ZwsNx
enUJ5Fz7AdPoGPlcpZWq2JDF8nMK+fb+HVYv/+ANF0zqdOVLZDUGTYW/UcsZtKzC
NJQm5+LODIeSE41U/IHNfA8rZvLqVacKZa8O1RG9b9OoCifngHa9W1n3y9PqFZn5
zINj+D2xI4djvYl3tnmGlKmk58dbhEcOoZYL8MSptXn8Ctkb50HQCrp8huJgRlkl
d78+8wjX55XrQg1SfUgZ7N9yNcQV1zpIHv+3ACTeRSA88lV/JPjx/TIYgrOW/MR8
gUjlCFPKIxZQOE0xyJqcbBH4xPTGd5piDm6ZMMh837KPkpRKOQ6RSpOHSwbqmjGi
nBkYEXdF9xnSrEzRzK936sRoDinTaeJ4vFC/sOj2wmL8FYJQZN4+zkyOjZ1ZO1Yi
1E3eT/v5mQuM0A8BhkaHXcdaTvP6/xgHv6gsxdYA3Hqze/8racoCJfFf6t5GAdQE
4sW7rQJkmDeaaczzKPgW37yelFN32lJNi/7pb38Z9UCoQGjglBRVR6GpGgqT0XVm
Sm6de92R5OvNXLearU1OgvvWj7lkjozjfV9eenInqt+hDA9IEqQXzv92scHC8w/H
jj+fmGEe707iqHrNp3NlpoJkYwILAj8ZnaR2X3vBxf4MZkfO2ScrbRPGbpm0zp/x
f8RcteiIb8qjLrwx6UKe
=6KjS
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--
