Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab3CAIHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:07:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52653 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab3CAIHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:07:38 -0500
Date: Fri, 1 Mar 2013 16:07:04 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Tero Kristo <t-kristo@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: twl: Remove VDD1_VSEL_table and
 VDD2_VSEL_table
Message-ID: <20130301080701.GP25302@opensource.wolfsonmicro.com>
References: <1360938181.7815.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FbmEh7Ek6NM6xKh/"
Content-Disposition: inline
In-Reply-To: <1360938181.7815.1.camel@phoenix>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FbmEh7Ek6NM6xKh/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 15, 2013 at 10:23:01PM +0800, Axel Lin wrote:
> Since commit ba305e31 "regulator: twl: fix twl4030 support for smps regulators",
> VDD1_VSEL_table and VDD2_VSEL_table are not used any more. Remove them.

Applied, thanks.

--FbmEh7Ek6NM6xKh/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMGGdAAoJELSic+t+oim9rXQQAJpU7I7yP+4fC1tl4BrvFCEv
/7xB70OS09PSHeyxxYy9j5oy5RYSuGulGQenvsZ4JfyE/owCuGXyj5W5axQymByi
BKFy1gv85lzvaGuOtXxXi3M5VvBVGPNEiUqTKVlPsS+DsQIrXWoniaj9EjwgvngK
rhFfh+hlY8hw5BXChHOmxEhjkR2vkIBIR5VrDd+FO9BMXOlePIDheXfxJx+XgKyO
kqkoa0f/SxVpJIqfzOqrWw7DOjfVC+S+aJCHhIwXyn93ODX5eOq+qFEORc+2n+IQ
7KQqb2jm1HQglfJN+Nlod6WhhGp9aSxtfsBR4SEFXSOVNtRIBg+TxkYNi1l+iA0G
9DF5fpsuJGKhdCZ83w+dNla4KEElaWRDnRd8Y6N6tMR+NpgMIhIQye/Rl2vtJss8
tHbd8c3CfhD3wY2/vjtbi8h3xHfOVwWwtegV5dI85CXWfU9/nskm6RlVRDbNpsJG
hVKtHlrSyF5hoyCA+btE3CO28wVg1jz+XKG+O8RvidUMNDakJSf1T2ooBfIHIEFQ
Fp4rlMEmlDSoRkvg1UR9mJRNGOSPkK13VkRKQgKSQz2Mix3fIBHwyNZ8g4GTwmvn
qXEn/N2Fm857TB2xpt9sJRASDmNaIi5iiovDLC1R2wbtlkRrM7i8T/61IvVhYu1z
NfJ+jMGkYi18G6ZElAeG
=q9GC
-----END PGP SIGNATURE-----

--FbmEh7Ek6NM6xKh/--
