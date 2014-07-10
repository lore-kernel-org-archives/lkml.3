Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaGJKlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:41:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57044 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaGJKll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:41:41 -0400
Date: Thu, 10 Jul 2014 12:40:05 +0200
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140710104005.GA30458@sirena.org.uk>
References: <1404941228-9922-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SuGb6p5JEpzYJdwO"
Content-Disposition: inline
In-Reply-To: <1404941228-9922-1-git-send-email-geert+renesas@glider.be>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: rspi: Relax DMA dependency and increase build
 coverage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SuGb6p5JEpzYJdwO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 09, 2014 at 11:27:07PM +0200, Geert Uytterhoeven wrote:
> As of commit ab116a4df4942c78c189d9b0744dd940ab9e00b9 ("dmaengine:
> shdma: fix a build failure on platforms with no DMA support"), the DMA
> filter function shdma_chan_filter() is sufficiently abstracted to allow
> building without DMA support. Hence drop the SH_DMAE_BASE dependency on
> SUPERH.

Applied both, thanks.

--SuGb6p5JEpzYJdwO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvm2CAAoJELSic+t+oim9GZYP/1jWu0d24zWkF7U6XdDurZJY
17EvfkjetLgueU1IvI5QXsM966xvLuLIik8m3OfCjtg6zpFdvIFxqsRDZoFXGNeY
fO0RpoiBz9NzQUDUMkgbl9lOer20x7uIYaKb0ZmJ4/CacDaf3wD5MhMvoI/0c7wh
bEEvBnqzkXTndl5R0BtZImQ5tiXj7ycUSysb2nu+pTUfmo0Bljg6/vnobwr7vR7I
64aiU+XZV/IVUCmS8+GGgq8vj9fWfdTlu0ZUTTnUCdobm5ziPb6sB4Q3yNQ6T98W
sSvq19JW0fuwDU9tKXV4gupOVTHTg7Ibfa0r5UPQn6FBGjsWEOTPurKCQZdQG0tP
bLskiYquo/wYjo0RDOXYfa8gnY3fF82Qlby53Qc9oBz5Lw92MC8Gebv+eY4q7e7P
MKC/VFrg8xG/TZgtFJRY8HoYIVk8Z9v89oPKeJC7cmtJNXnp/Kc+RMWcGNzKW8zr
zRIpoK1dMYJKPKjgfyi0fvadTScB5nFS4KECDoIMd1WhP3IhPGu86IRG+XLakVWD
4HmRzTYWGlAugUeZu6gXCuIH0De6qqSX9OqB9bByRY5QAnCDxzpjz2lCLiR/JOLF
ADYpCLBKBlIQW2XdF3Pb0ofPR+ndEWqQoHdSlsSysLfWe8zE5Jt5U4erish23qRa
NtFhWnxLz78b5tl60W0o
=k6Cz
-----END PGP SIGNATURE-----

--SuGb6p5JEpzYJdwO--
