Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbaIPQxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:53:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45334 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaIPQxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:53:53 -0400
Date: Tue, 16 Sep 2014 09:53:47 -0700
From: Mark Brown <broonie@kernel.org>
To: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140916165347.GP7960@sirena.org.uk>
References: <1410865454-30102-1-git-send-email-jarkko.nikula@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s8GAKpHVZTOrGbze"
Content-Disposition: inline
In-Reply-To: <1410865454-30102-1-git-send-email-jarkko.nikula@linux.intel.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: cache: Do not fail silently from regcache_sync
 calls
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s8GAKpHVZTOrGbze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 16, 2014 at 02:04:14PM +0300, Jarkko Nikula wrote:
> Call stack of regcache_sync calls may not emit any error message even if
> operation was cancelled due an error in I/O driver. One such a silent error
> is for instance if I2C bus driver doesn't receive ACK from the I2C device
> and returns -EREMOTEIO.

Applied, thanks.

--s8GAKpHVZTOrGbze
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGGsaAAoJECTWi3JdVIfQsEgH/1VHcUr2x60N/zR5l+1CUy0T
ws79t8xkOuqBKj4/vtxdYEJUGhHK1hy4URkb9OWquWUU7t06p5/0sMdnMfKlj/be
03QYYIEqAnHmYH8NP4QAaCCtx0L2i/khMxWTN+Hbfxn7QdHunakXsmGDNRaFoFM9
YzUhB5oU5zPFKis9l1JPBE/ry9o19GVctWGjjr1ugfcaidfpL9ofw3Utkf1B8pYG
3XENrejAE0ge8uX2i984Rdpp0FgDF71hDAx+sgjpaqd45IDxu1URIvv7kV7z8cYC
KWfzzBdEkncwE+g2d2VcAzVvTa8LWOhJpHnVifYvoWEUTCS3vWOd22LTHaDLCx4=
=MvjB
-----END PGP SIGNATURE-----

--s8GAKpHVZTOrGbze--
