Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3HEOvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:51:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33049 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab3HEOvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:51:31 -0400
Date: Mon, 5 Aug 2013 15:51:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130805145128.GJ9858@sirena.org.uk>
References: <1375694489-12790-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tQ7yrGZhmC5JiArN"
Content-Disposition: inline
In-Reply-To: <1375694489-12790-1-git-send-email-lars@metafoo.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: cache: Make sure to sync the last register in a
 block
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tQ7yrGZhmC5JiArN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 05, 2013 at 11:21:29AM +0200, Lars-Peter Clausen wrote:
> regcache_sync_block_raw_flush() expects the address of the register after last
> register that needs to be synced as its parameter. But the last call to
> regcache_sync_block_raw_flush() in regcache_sync_block_raw() passes the address
> of the last register in the block. This effectively always skips over the last
> register in a block, even if it needs to be synced. In order to fix it increase
> the address by one register.

Applied, thanks.

--tQ7yrGZhmC5JiArN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR/7vtAAoJELSic+t+oim9d/UP/1fYrO0SOyUjdMrDb0blsuoN
YdLDuVMnh9Ht7WMFR2ohyesMqgz1U/n+I8BNBnjR2HD68qCtStpWfYEVt8czThZr
Kkxm0FE92kO2F8UkwEJVXuj6OOAM6ULSBkjIJkt/gTKA9qICBvih2VoIGvElc05S
Pm+5qJ6BZ23jVYDQpaqkx1wSLY0sJAJ4Q4YSiL/uVoWSiFW3LAl7yoq3orquKKlp
hRy6Sdju9O/ErmbtLBqQe9ds7MR3TxhMcsdws4bS7gGLd3vd9kU2wCLgGs1xibq8
p7tuLQnd2PaC9WBzcwLhWy/NiCmwfw4DhjECcZqK0S1ox2KX8Ji72a6cQsFEgm/c
iRg2F/5L/i5G36R9kQCkGxzxHmy43NKxEYyDzt0r0yD5HZIV4Rqd+Dyaae59fIka
pauxMPUtz6IhscMK+b7AjbSqf+ulRTJuP7nnpdzXGqwVP1NbCWomPGPPlnqu+xak
OjoqxzaKwfJQgfjoznytxTFPgrLu4qE3G8IHyPO8eaLXaXjXND2OtWQJvmuP1iGE
fmzz0m19FSukU+UwEYyYCsc6YIr0yVG9ZuyEh367kt0cXgDHiBF33Nc13Lp5jkMI
TQZ9YJocttt1O3+4+3guKsm6b6fWJ3BYCSh6cBrMiYeEXi7EJqGD1KvZ55LabbIC
cf5xoqRm7DGg7QJom77j
=kHs3
-----END PGP SIGNATURE-----

--tQ7yrGZhmC5JiArN--
