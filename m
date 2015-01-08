Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbbAHRDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:03:24 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50768 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbbAHRDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:03:23 -0500
Date: Thu, 8 Jan 2015 11:02:36 -0600
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: Rohith Seelaboyina <rseelaboyina@nvidia.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <r.baldyga@samsung.com>,
        <andrzej.p@samsung.com>, <joe@perches.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] usb: gadget: ffs: Fix sparse error
Message-ID: <20150108170236.GI31926@saruman>
Reply-To: <balbi@ti.com>
References: <1419422401-8401-1-git-send-email-rseelaboyina@nvidia.com>
 <xa1t3885qg8k.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3U8TY7m7wOx7RL1F"
Content-Disposition: inline
In-Reply-To: <xa1t3885qg8k.fsf@mina86.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3U8TY7m7wOx7RL1F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 24, 2014 at 03:23:07PM +0100, Michal Nazarewicz wrote:
> On Wed, Dec 24 2014, Rohith Seelaboyina wrote:
> > This patch fixes the sparse error in functionfs
> > driver.
> >
> > drivers/usb/gadget/function/f_fs.c:400:44: error: bad
> > constant experssion.
> >
> > Dynamic memory allocation through kcalloc is more safer
> > than declaring variable array size, Fix this error by
> > using kcalloc for memory allocation, Check if memory
> > allocation is successful and return -ENOMEM on failure.
> >
> > Signed-off-by: Rohith Seelaboyina <rseelaboyina@nvidia.com>
>=20
> This has already been addressed in a way that does not require dynamic
> allocation: <https://lkml.org/lkml/2014/9/10/513>.  I'd rather patch
> attached at the end would be applied.

can you send below as a proper patch ?

thanks

--=20
balbi

--3U8TY7m7wOx7RL1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrrgrAAoJEIaOsuA1yqREuWEP/0fXGXsyzKL9hKjZWl50IlBP
d2XMVPwlOR9zNlSSz02QKyDWnnie5JaE9x/l8YAAU8BKVikQLmaSvBAvbK1zIkgc
EKDMQwE/5OxKEoO4u9UHY5+8FvpWmV25NzemyGYou9p1S4EjyycUfc+EGu3/VzwH
lkzHTdPux39e6mgqSk9yXcOiVdX3wV5mnkz3BFpQTnrVHruqygFgJzF4pficlf79
8knf4jNjSIo6+qmMxFSUQXIgTrSw21WqAXdVcWdB9JqIQ/yPMdg/kc3WMgBrw236
PBH90YtodCmhWUmpbqoQngiKD0V5lt99D3MOpkZhhmk2/HKJAVeUYDftncRyLdVb
+GBAf3+o6DZrWcabiffBZRRezBl85MBRnOVKiKWvG1UWUQMqCGlRyUI75WkY9Zx8
u9oM7d3fEDZcviXXeMTDfjFOnmN6/43qN1rGkXsEJZKZrEWC1V9OkThHpn+9RweW
B/+P7GvCNDJ+AUCDrtFaDBSLjiev8Y92hjnEFqzi6m0guM0QL/ciF+CoC1ieVxSK
rf3AeiWnCn442qJe8feF/kk3op+7/TdlI9SDUx9BDNanjAriVRhlWZXzlkl9SxfX
VxKelIzQ1+Ou9/qLCms6cBxkRs8ZMxb7VrITiql5GEoWYVEnJET+PemJXSGe5NOr
j1mwzOLF+YjTg2DsEBeX
=UGBO
-----END PGP SIGNATURE-----

--3U8TY7m7wOx7RL1F--
