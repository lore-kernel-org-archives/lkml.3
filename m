Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966529Ab3HILrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 07:47:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34559 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3HILrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:47:41 -0400
Date: Fri, 9 Aug 2013 12:47:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20130809114718.GB6427@sirena.org.uk>
References: <5204BFD0.5080305@nsn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5NsQWDwfMDrsTk14"
Content-Disposition: inline
In-Reply-To: <5204BFD0.5080305@nsn.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regmap: regcache: allow read-only regs to be cached
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5NsQWDwfMDrsTk14
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 09, 2013 at 12:09:20PM +0200, Ionut Nicu wrote:
> The regmap_writeable() check should not be done in
> regcache_write() because this prevents read-only
> registers to be cached. After a read on a read-only
> register its value will not be stored in the cache
> and the next time someone will try to read it the
> value will be read from the bus instead of the
> cache.

Applied, thanks.

--5NsQWDwfMDrsTk14
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBNbDAAoJELSic+t+oim9BOMP/27pt41k2cY27XEdVmvXEi2F
dtviQDhe8AzmHgbsC6k1ZGW1DAg5sDKXda55BvS7qXjXCKVo4AfSRDOKZyC3Sgkf
VVyeLye4OkF6cgksg91ogduvQVtkdOhobLs6PQiforRvfc2HGwFwDEIqdZ3FQYhg
Rjolioo2Gxh7lReWJy3ad4UB4aktxHcDUO7uCJjqivyUig01GA+awaySuwJhjqT7
+5TkqKDnlgt21kDD9P/Nm0iRr5BOwNLrE7VwnsG9Zfjcu+d71Tq6FVXKTBc8CGwC
INYOk6ABrP8hrq8b4yzy1aTSwxVgFM17EgQLPelj+S4ZvdRmJHw5xDCQm+gHWjus
abKmG/G5pTIg87Wb/wW3K4ej3v4ZpH5l/gum5v4OLWVDrpurJ6vGpQGNvnYOJR9s
FYvoy53sAfFpu9Ep8QQd9AbKhseBxgCt9S7PMFV7p6vb0GLiCSk/6oHYDOLobBHf
A8kyGKshl8oTBga3qraG9rxv3GZTTCzX7GgHL4kBeRDTV26ZW/Vqd1wFlzhZt2oq
GJOB6adHUj6EXdKfbzOYTJzpYA/E9U1Q/cPWqSM+Tp6yZtOSmu+iPKoPl3/VCjRf
ttfOmYJxKZteN9BHbCoNtThGPOYQjrqkV1/mbtSWf6RposXrKu/kqe5X66E2wybF
e8vJPcrY6CkMDdUI+9P1
=LId4
-----END PGP SIGNATURE-----

--5NsQWDwfMDrsTk14--
