Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934586Ab3BNMJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:09:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58046 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757537Ab3BNMJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:09:48 -0500
Date: Thu, 14 Feb 2013 12:09:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regmap: debugfs: Simplify calculation of `c->max_reg'
Message-ID: <20130214120945.GG13249@opensource.wolfsonmicro.com>
References: <1360841608-17191-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gvF4niNJ+uBMJnEh"
Content-Disposition: inline
In-Reply-To: <1360841608-17191-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gvF4niNJ+uBMJnEh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 11:33:28AM +0000, Dimitris Papastamos wrote:
> We don't need to use any of the file position information
> to calculate the base and max register of each block.  Just
> use the counter directly.

Applied, thanks.

--gvF4niNJ+uBMJnEh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRHNPlAAoJELSic+t+oim944AP/jnkTzC0P/YBDh+y1q1GY852
JhdSPn30PlQSgqVix80VyZnIH+Mkk2jdEfxNhxrAWFRZ/FzUSOeUuGIVZQ+SXanT
h3z19CHPYeyN1rY3fJFC3N0Uv4qHQHp5ew6gP3vIq4axPthN7v7H4gR+mDgIsNgC
Ret5R76DWTFOB7L4+Xu9cDWn35bL/UarXcAH1tkLYMYzd2WqL5VpoTsdzg3Zl/4w
7yCNPQk0YTksqnYZovK0JURNPc9eosCRF4DeXkHQ4hTtTwKdsUczulhH/yIwdyms
ekO3jo+pLG1pfxT7TxIJcRVzfui6po6zY14mX24+DrCi6PnNLd87zV4k2fK/d3Py
7nFI6obiDt7VnOkbHQdDJnPLu7KicmfOV+dWcYJDwEOyBWpeuy0YPWFRBg4MRDit
5naMv464uiOw0STEZLNIC2qaM+z0oOlqK28DMVlD7e6EJJa9aEjqQiAfiiX05HUr
VJ80tL4wK+EVPWRvDv+xyU4pG3UHZ1GOWoZ2W/HG2xr2RMZowHPf5S2W8A4BIcdq
E/nzdbtBZleCvvw2hWQw9slLXauWhlRTCIaJsISBDyvPTcw7PYKdUTRdGO04oi+a
HXe4Zns7+aRr5HyBStF04HS94GgKEFt5kZ5dEj39nFhWQAM+phzMxJE9K+FN/Kdc
4K8OkzuHtrCFeNXVcpij
=Db6r
-----END PGP SIGNATURE-----

--gvF4niNJ+uBMJnEh--
