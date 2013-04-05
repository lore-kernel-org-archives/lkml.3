Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161764Ab3DEKWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:22:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45031 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765935Ab3DEKWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:22:23 -0400
Date: Fri, 5 Apr 2013 11:22:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
        lrg@ti.com, myungjoo.ham@samsung.com, kgene.kim@samsung.com
Subject: Re: [PATCH 2/2] regulator: max8952: Add Device Tree support
Message-ID: <20130405102221.GE6597@opensource.wolfsonmicro.com>
References: <1365092240-8956-1-git-send-email-t.figa@samsung.com>
 <1365092240-8956-3-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DqhR8hV3EnoxUkKN"
Content-Disposition: inline
In-Reply-To: <1365092240-8956-3-git-send-email-t.figa@samsung.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DqhR8hV3EnoxUkKN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 04, 2013 at 06:17:20PM +0200, Tomasz Figa wrote:

> +	if (of_property_read_u32(np, "max8952,ramp-speed", &pd->ramp_speed))
> +		dev_warn(dev, "max8952,ramp-speed property not specified, defaulting to 32mV/us\n");

Applied both, though the above warning seems a bit harsh - it seems like
assuming a worst case ramp rate ought to be totally safe and just a
minor performance issue so silently accepted.

--DqhR8hV3EnoxUkKN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXqXUAAoJELSic+t+oim9qjMP/RcN/I75yaRvGz5361wf3kMk
jogmGn59Rj1S9MmpLqw6cBGa0yDh253Rv8rHAHBgw9R8hK1KE8xc3zF+qoaSDMT+
i2BSpbgC9fC882BzOdWxoqljlwa3LVtw4uqC0eDPYeC0aV9Y8EgQ4gIx8kw5EZa2
607murpSy7hDYMA091leJUJwuQ0snAuo5LWFO+m6GJ11XdwN5pordVE7aYhq/R+C
anrQEfCtuIok1M4gEoWn8kf/bcceZKEfkvIm9MKhO7zscmw9rOUWYKs3LiE71mdz
b9NYsZKtqBdE4sgTcpFtqwOZIXylcsADbq241qemfbi0tBkEoivOGsghhxG9ohnp
F8rhR6j9alFpGqN751H7VxCk6Ntag1gEwJUWiO4NWSNAPzjeyNEeJ/kpLZG/EjQn
2YwT6jOsXIlbapl6WQKohYIB23JswkE3BIbIXkKu29H+ufz5jKAMBwNhT86u+F09
5e6jxM6ZVFEcB5nMXf/U5mUmAny5VpOcKS3x09cS5YQ3GOu4ZIoo2c5TbRZiA3SZ
4sYnUBvso8nCJgpGAyG7s3TJ3FDeiydZcUYE241vBEBrtizA/Fl+DXJnCxpGhJ0h
At7eFpkGWBi9ResksVOdpTP6+tGPVqkrgUSSBmN4AC0S4GV+ejoxO94CfoU/wrNB
HsOCIkUmJ19j94J4Rq2c
=uoC8
-----END PGP SIGNATURE-----

--DqhR8hV3EnoxUkKN--
