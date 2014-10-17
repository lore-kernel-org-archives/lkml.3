Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaJQI6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:58:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60815 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaJQI6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:58:32 -0400
Date: Fri, 17 Oct 2014 10:58:20 +0200
From: Mark Brown <broonie@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Wenyou Yang <wenyou.yang@atmel.com>
Message-ID: <20141017085820.GD3771@sirena.org.uk>
References: <543feff0.QhS1UtLsJt/o5948%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <543feff0.QhS1UtLsJt/o5948%fengguang.wu@intel.com>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/atmel: fix simple_return.cocci warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 17, 2014 at 12:18:56AM +0800, Fengguang Wu wrote:
> drivers/spi/spi-atmel.c:1518:1-4: WARNING: end returns can be simpified and declaration on line 1514 can be dropped

Applied, thanks.

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUQNorAAoJECTWi3JdVIfQoOUH/RZWWUb1j56WILiSzVPqOMnR
rHX0RDbOPBu8Jwl3jx5f+kMcjjh4kr3P3M70wzMk/locGk1H3cgAd2RJhznKpfhK
IcqzUMYpahJSjJr6tq96apRLOWeoznRHRSUxDENUqU87gDbaFiYH1WGRDTsVFeDn
r+qWj2Q/JkUGsxwEG3/R6HbpDx7kxJU5MmTYQkJq6s/9iaISvx89hTkuSfqHFgU9
Tmp/ekie+UZcO2VykTsP3+B3CyP5gVJO90xz47yyCaBQaQjvYJ5eruAVOYZEvydE
LRqE6h96Zs7g5olMqhdsaKduvcAFiJkIB9BCoNMlEAEQqwWVIFSHvAgY/G68RRA=
=2khw
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
