Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbaLVRyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:54:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44215 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbaLVRyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:54:36 -0500
Date: Mon, 22 Dec 2014 17:54:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Sifan Naeem <sifan.naeem@imgtec.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141222175423.GE17800@sirena.org.uk>
References: <1418763946-22260-1-git-send-email-abrestic@chromium.org>
 <1418763946-22260-3-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WeoCK3UN7lwjrlbw"
Content-Disposition: inline
In-Reply-To: <1418763946-22260-3-git-send-email-abrestic@chromium.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] spi: img-spfi: Increase DMA burst size
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WeoCK3UN7lwjrlbw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 16, 2014 at 01:05:46PM -0800, Andrew Bresticker wrote:

> A 1-byte burst size is rather inefficient and has been shown to cause
> TX issues during testing.  Increase the DMA burst size to 4-bytes for
> both RX and TX DMA when using the 8-bit FIFO.

This sounds like a fix for transmit issues so should go before patch 2
(which seems like it is a performance improvement rather than a bug fix)
but it depends on that patch - can you respin in the opposite order
please?

--WeoCK3UN7lwjrlbw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmFrOAAoJECTWi3JdVIfQffMH/3kVEvTPoUPb2IwVV+KJFduj
9KkucTRLNV2/3hoEcgIYlXZ+iZO479ytbxDFILIieEnGsSa4Gom4FMhy/Wg+77/F
0EGR7hQag7Lx5qwzy2PjOyqaagjlzmhJdu/b3C5CwmSzv2SPh7jnuLHWvYc+LDNz
PujQrhJy2IZJtmpDnOGGJ/oaALW+p4BvM4qukWGaLKlVRKiiTl8PUpOvE8WE/jFd
a1QcKXKWpwT7YqaGf7ZAQN0BqqQrmFOl2tJyvIbg18uuqwDD06kVXXPihQWI30MD
wwUUqKVLglGJPgqgdgXp09F9ifvIuIzPfu1G/oogl0nRQrBNsnXmAdNtjekU/tQ=
=B5fd
-----END PGP SIGNATURE-----

--WeoCK3UN7lwjrlbw--
