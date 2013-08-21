Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3HUNcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:32:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41614 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3HUNcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:32:04 -0400
Date: Wed, 21 Aug 2013 14:32:00 +0100
From: Mark Brown <broonie@kernel.org>
To: David Jander <david@protonic.nl>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130821133200.GB26118@sirena.org.uk>
References: <1377090155-3443-1-git-send-email-david@protonic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Content-Disposition: inline
In-Reply-To: <1377090155-3443-1-git-send-email-david@protonic.nl>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] drivers: regmap: bugfix in regcache-rbtree.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 21, 2013 at 03:02:35PM +0200, David Jander wrote:

> rbnode register ranges can overlap, which is not a problem as long as

They can?  They aren't supposed to and I'd expect this to cause problems
with the cache sync code too.  How does this happen?

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSFMFNAAoJELSic+t+oim9R1AP/3NbFnN2cyBjqcBM+kttZlmc
JVVQOTnQB8zSN7jNjKR3Beck6gcjIZ6iayaoJdD3/swi+GUpOR428AOsm+8KzpKV
B44S5QJerQWdL9Yye0PTvhQHvyoLiDaYR0dPSmi3A4srjBbA5XZb4PZWEbZupdlp
GKkWl3z93jGgd5cdJEezT686Yrw0FEkHlt6FgfxHg4LR3TE9cpbf8SRUgK/CNal7
0UbBILSRmJ+IbudSwm9EcfamnZly8Eg5foZe/eECDco/sbicqXOkkztFVuQFwyHu
smWukvCJGGf3ThOhKyhYjwIr5okVUve2FIuWMXcmt3RNK5XAG8qGkNLtJi88ZdAg
4ujqrZf0QwwFA2iurw+mHMsSDMmmhifrWOTiaFtq1zrLeweolTAhTclicvnSI9fU
cSSIynyDcnA8RUqU3hVs+Ym3CuuoZA8MonHcJpEuDn4CQGhIGQk8mZMS1NOu671B
b5F+mbyC7Qwrv9QUc0O1D2p9L7GB2TuhwN5aAGL6afkB0OvqXuX1eAFLna+a7PCZ
mcx+u6B9+tOYtTo03TtNK/uctwhH86A6TyN+ovnXfsBDkYmriFNNE+zlZsaQEbPy
+EvrzUP1jOAAUUCWiK2x7/sGtbiw30rptWz7UDCdm2Ey/tY4o4hCU6tle/Q2Zy2a
IbIkiBmNwo56u5n4Vp0Q
=hXCc
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
