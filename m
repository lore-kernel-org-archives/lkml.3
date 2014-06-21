Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830AbaFUKUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 06:20:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51779 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaFUKUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 06:20:06 -0400
Date: Sat, 21 Jun 2014 11:19:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140621101959.GM5099@sirena.org.uk>
References: <1403259380-13634-6-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YLnPAZt6hMJRJaYl"
Content-Disposition: inline
In-Reply-To: <1403259380-13634-6-git-send-email-geert+renesas@glider.be>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] spi: sh-msiof: Add DMA support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YLnPAZt6hMJRJaYl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 20, 2014 at 12:16:20PM +0200, Geert Uytterhoeven wrote:
> Add DMA support to the MSIOF driver using platform data.

This doesn't apply against current code, can you please check and
resend?

--YLnPAZt6hMJRJaYl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpVxLAAoJELSic+t+oim9ghYQAIjz6RIL2o+b5ycDBzuFSm8+
lr0YgH8kRPynR05UemER43yVHV88rjWhVjyumHvf0vxRtrofb1t4iw5sqH/ig83E
RXaqgb1XriXwywQcNb0+Is3oFVtDZPCEOju0iCUSI28bfE8NKKLgDqVv8VI7rB9F
2B5TRsJEfiqdLekyiTnYNDcUjDlCjUurEr7fhbDZ20ompuvWMP6ejBrbRdsZL+LS
MVvXlygqrIXalBEo//TAifoKsdKG86fu+3ax8M9S5QL2uIlGNFpy5mwgAu7SvBZz
rKCR2zB4sNYY5KEMr32aORXr5js+REWWffMrVJ5YWvqZNcvboehixTNrRhKcSb8C
2yFMqSFJ6csZ7kR3Woo22IG1ja20ulzrrc+mnrATctdwYbcCC5jZrEMwoc64rpzA
9B/H0/WG4hxhro2eMzhOX4gopA7b+elwQRRuGDIQ6O7rmLh1BW5Sqq4SYjPTTU8I
lzy6exRwWvfypPEsN53Xkx6eOI0Idm3l4lP/ByZPTVqYsKCeG6gjqagkjwVo+Sed
+Mn9CorKat0XquJeru1i1KKUvXGKyKKJXWLQ/mkHAS/SzS31DTvRG1npNMqoUEOP
4SQdxwjBB6lHKg2aw3Meq2bg+Y8HjfO+vqRQoOwBY5vI4s7MpG1fzAM++3ZbJL6E
U9BZqWnThZFXds3vxG5b
=jy/x
-----END PGP SIGNATURE-----

--YLnPAZt6hMJRJaYl--
