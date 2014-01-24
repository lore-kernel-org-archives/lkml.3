Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaAXR0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:26:33 -0500
Received: from sauhun.de ([89.238.76.85]:46115 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbaAXR0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:26:31 -0500
Date: Fri, 24 Jan 2014 18:26:28 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 51/73] drivers/i2c: delete non-required instances of
 include <linux/init.h>
Message-ID: <20140124172628.GG2629@katana>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
 <1390339396-3479-52-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUk9VBj82R8Xhb8H"
Content-Disposition: inline
In-Reply-To: <1390339396-3479-52-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUk9VBj82R8Xhb8H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2014 at 04:22:54PM -0500, Paul Gortmaker wrote:
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
>=20
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: linux-i2c@vger.kernel.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Applied to for-current, thanks!


--SUk9VBj82R8Xhb8H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS4qJEAAoJEBQN5MwUoCm2D1wQALLYlIZCskMnqw+LQShbM8I5
FdW7yAOiQDfszgmSPax0T+VNEiN8n2VZHpMAZmLX45T0Lbcxcfc4D4+zQXdHHopa
1tqzNR1TYK+uPaGtLztGdz4dio6o0qgZkrr6x6cmYeQbNde8mcgMiCAMvVzexw50
5e7q1XNKHzErWwAvblet9d87mh5UVJaP37l1G/eC9LckMVzUjD1dymIBhjNzTm5Q
x5+rGlTAfEIEOxqLfRfdsCE6eRZBi44FuZNNhH9aq4SLBIpcJZs9oGxQ6qK6lEfy
vxIF+DbLkgbjaXhGtZZWgJDV/X2SV6qctMqFc9d7W/B3qmc1kA/St8RKbc0JYxx1
M+w5DCaqOfa4TQZ0Z/I9Jc2UkJjSN4iIn8QCuxCPrM34yer/3nxRpfzrcvioqUsb
kE1pR71PhOhUZgMIPVH30blHjWYl7RGla4rXvNf4EIEZcQkqDoZEg2roKtsB/FNH
1mzJ0TFs5g47PLBGem8aG06Cv3qEUOJj3ubie4zoOu32QmiNd3D1OiSeiJ2YVc7T
uvuPeT18lVTAY/ADPHwCk/a3305dNsJ3rfCZ2mhGa4wR6yjO3GL5Zo13rwUJcZMN
MYUewkKO+UzL6f6VTFkWNKf/aWO9AeBb5jfqBdZf+fvN+JJkV+mk7WF6Z+epIuVB
JdBtM2MygNozdUI1GBR1
=ta7I
-----END PGP SIGNATURE-----

--SUk9VBj82R8Xhb8H--
