Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934771AbaFUKSu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 06:18:50 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51769 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934720AbaFUKSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 06:18:48 -0400
Date: Sat, 21 Jun 2014 11:18:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140621101841.GK5099@sirena.org.uk>
References: <1403259380-13634-1-git-send-email-geert+renesas@glider.be>
 <1403259380-13634-4-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RY9YeianT1w0Sep/"
Content-Disposition: inline
In-Reply-To: <1403259380-13634-4-git-send-email-geert+renesas@glider.be>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] spi: sh-msiof: Improve transfer error handling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RY9YeianT1w0Sep/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 20, 2014 at 12:16:18PM +0200, Geert Uytterhoeven wrote:
>   - Add a timeout when waiting for the transfer complete interrupt,
>   - If sh_msiof_spi_stop() fails, there's no need to clear IER, as the
>     interrupt handler has already done that,
>   - Propagate transfer failures in sh_msiof_transfer_one().

Applied, thanks.

--RY9YeianT1w0Sep/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpVv+AAoJELSic+t+oim9HT8P/iS0uUbOhlYormuxVepE9+2t
24hXixtRoj6frqBFGS7O9RwooSpYQkTYBpzHuQ2OZ5jYh1EaT/F/X5JT+W0W9rdb
LAHqXe1pTdGgAkJlDj2DrkCFN7I+6iD0kHkiftT2mjb6O6hhE+HfwOCbawuEpyng
EZzvqpAuTF7np0evUW1ZJXtcPCdK+zy3Po1fkvPL2qG+9FumDvZ9ltqYI1qIuQxf
q3tH9QHk6cWZix3xM3zfYlNUZlxKD+0SyXNlLWjIAfgLj3zsmEnveiicmk2vYQTL
JpySlcWdwGDf+MeIgL6fbROeYD0fhYXHh10Etb8y3NHYOgJ9KKYefWqxwQSzuijx
bhbj4KcKh3RKqYCd4lRV/pZ301+wBPAIm1rUPP/NcQjZ8URDccB912fOHrt95EYL
EwLlojsWe/te8XEwXKfW1xuKK6gsA4K9n2eYsHMxApHhOmBR/HHQm4Lvg0F9vETl
n9Hult6D9u/hDAJMyWsD0T9yNxxmC6J4GXLNcCNAt4fN3N3Ql7RtNZvwyE0qd9cf
I8BlL7/iWXyG+yULSuqG1tN4eLPtzOk+gRWHDoglTEETeN/DwGkaEaiD/+kEuaFh
mdqqQhCGEeNTa5aPxzXuuZWLyVrVnga+pVGALZ7NgmVrksuodrMa4DmzjSpfl4iW
g3rMADt70ECe/R4U8Jh6
=EQ8w
-----END PGP SIGNATURE-----

--RY9YeianT1w0Sep/--
