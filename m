Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab3GDMzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:55:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57647 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3GDMzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:55:17 -0400
Date: Thu, 4 Jul 2013 13:54:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <20130704125454.GZ27646@sirena.org.uk>
References: <1372936263-14472-1-git-send-email-zonque@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wr+6IbPut5sjYcrb"
Content-Disposition: inline
In-Reply-To: <1372936263-14472-1-git-send-email-zonque@gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: cache: bail in regmap_async_complete() for
 bus-less maps
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wr+6IbPut5sjYcrb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 04, 2013 at 01:11:03PM +0200, Daniel Mack wrote:
> Commit f8bd822cb ("regmap: cache: Factor out block sync") made
> regcache_rbtree_sync() call regmap_async_complete(), which in turn does
> not check for map->bus before dereferencing it.

Applied, thanks.

--wr+6IbPut5sjYcrb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1XCbAAoJELSic+t+oim9PB8QAJ2dJKwAEFrUzbo5xGF8BnLE
zebdrL5YNrI17ewzfJdmRY5zu6EfZ5Rnci9jxKntJqMHEKbnbclGHG+GpjeOykIk
vLbUsHNvdwYxLZjgeURLr34xCisGt7rDiMVk+1iGoFloRuPCXibhJaIzHnY5qEhz
lQML4M7DhdYfx2JTkOOKsUULKUclFv+rBtLXUjGyKSTHZTnwpo2CiwU8+1457pdF
Rs7AUBe9Z3yUr6y2hBX8XGPZ5FGx6nITq7GK+p0rOVBpLXuXjjURFJvxSr6bWCBr
FUrkoOOK17vaNTnzStFFL1VvUWpZqQHHLtV/m64hJw8R88RI50t7XAdhjcoIH4ey
5nwwPlTPJ/P7SDFG/sVHkPHFpZQ5MF1igWuA8/rASBbp2NzUuzPyNSsH2hNw3lkn
AlQVHVYHjLWai7EJGc42GprZv8xBKCFRjvr6t7n/3VXZhsQ3GEnRKzMTS2XL2XdD
IDj3n0kcGBQ2q43Lygq9dG1BUcM0B3ynb9yaI+G+tTQIKL6GFMtEen4D/gsPGjJF
a5UtB+gt8mRMBHJAmFL+aVMRWociaZhUGfEfNcT3V+5EUskxkKQPdSHDsudaC9D6
zBnbLSUbGW0VZSRk212iJuLvfSRgtj3sO7Tpfp8O3D/+9XobAmqyfTcKQcBFu/tT
42XouV6Z54Dc5/85hbpQ
=SFym
-----END PGP SIGNATURE-----

--wr+6IbPut5sjYcrb--
