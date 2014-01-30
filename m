Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaA3QvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:51:19 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33006 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaA3QvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:51:08 -0500
Date: Thu, 30 Jan 2014 16:51:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140130165101.GU22609@sirena.org.uk>
References: <1391088392-6504-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="McQJJYUzjTUqtsGv"
Content-Disposition: inline
In-Reply-To: <1391088392-6504-1-git-send-email-pawel.moll@arm.com>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: debugfs: "registers" & "access" for single
 register maps
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--McQJJYUzjTUqtsGv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 30, 2014 at 01:26:32PM +0000, Pawel Moll wrote:
> When a map covers a single register, max_register is equal
> to 0, so the "registers" & "access" files were not created.
> Now they will be, as register 0 must be readable for such
> map to make sense.

Applied, thanks.

--McQJJYUzjTUqtsGv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS6oLyAAoJELSic+t+oim9LOMP/RVmVXKErMRBSPz71ZHd+YAK
dHuoGRXb8/AYp49bqviCbzzYJtIr5J6UZeOyhEKaLWu0gttSnuIoCqmjcUY3LRql
em27zMggjnV3Dec5HIUDWefdvif75eMQp0bvu1dHuIXp23vpWtlZtT+G7hCmT4OJ
ldnrK1AqcXCLgqINTvIgRJ7WyJW5QxbTAOk9jF8X3YENdiMCcvzJX+fP28KZSHFJ
y6UXagZYwsgJEYm86khWf63d/JamtsJZyTAx6EgUjYzBb0wkXyYw7Hahmu9o3gUz
gNlgF0fmOIJLwmZqyBVyWaE9C8LRCK7HLSIDAVodQNnJLpb4Ry7dwSxHT6NwOKaz
4tHVzlrhz6Ly+6+f2XBS58+zboZ4FoGLd9Wn0Hawb1MQwxasnRodWDTx+AZxF3Vl
YkA1H6PoJJqMOtWWIM9JX/d7iZxCFFADVURekYh3WZxI6xHdLTW6yPODsLGBr4Uh
agWpIqcnUEu42oHtjI6/zP13Dz+/vkUFVF1ajH4kZwC/U+reLZt5ZS/l/kqzTetX
l3IZxNE4M6e/Si5YdZPfYvueTv0svndkcPXxFi4TfxrK4q2ywGF9EEpbnklPmcsB
h0Cbzx7lfr2OH3qKLCcB+HDxSsV/jtonuRlSEJUmtu5VZDAuGd4RJ9pRUg2V3r1W
PxiFcHGaZW8Q724437ls
=Of5L
-----END PGP SIGNATURE-----

--McQJJYUzjTUqtsGv--
