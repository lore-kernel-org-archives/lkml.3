Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbaAUSMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:12:55 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57661 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaAUSMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:12:52 -0500
Date: Tue, 21 Jan 2014 18:12:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140121181248.GK17314@sirena.org.uk>
References: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
 <1390317009-8292-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rYkcoROieYsUh8uu"
Content-Disposition: inline
In-Reply-To: <1390317009-8292-2-git-send-email-geert@linux-m68k.org>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/5] spi: Clarify transfer_one() w.r.t.
 spi_finalize_current_transfer()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rYkcoROieYsUh8uu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 21, 2014 at 04:10:06PM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Applied, thanks.  I suppose it should say an errno is also OK but I
guess that should be obvious enough.

--rYkcoROieYsUh8uu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3ridAAoJELSic+t+oim94OIP/2IBPQT0IC9xeOlQHgGVVIuC
j/tnUFS8gwSdjn8lnCs/pHwa1CITvJ90kq/3M6eoBIEDGcUg9te5QLEw+WVgNAcG
XvzSYPLD8UY4cSHbQNadgskK3Bbr+p9VfElX7gcjcj6QyDoanQtzk9refqEiLo2D
jmsIRfshECZ74vGkd/cscurQMB1RI6O6lNJvPGx+2iymKCYpKCxp3XGatNcF1rp6
ntoJnfdnwB5ZrjIAOq05/I/344I/2wcKj9s0DKInng+HMpC1LFsagD5RIeRj+6Iq
Iq01r2/guqmei+zB/buscisUac8IOqhaHoQXtNxxCFZOZBZmpvEqr7GGQL09AXSC
QmVlE5n2j4RIafl3gn9cEyMg0Osz/fze872RnVuriULYqqOPM3b5jbsQxsOXeLTh
IQKx7SAGgnR4VNJKSo5gfnG3AKBn1Czo0XClgP1pSyxke2NmRCOA7zB2dGpdx3ow
J2P9JIImLzqCqSBVRNwSZiD3bFFeMtsFDk0m14s2ZhnFENUaOIJ5s1KoutktoxWh
WH+gDHOFoSS+uH8VMA9jEV3pKF3UZwdWoLGH6ZFz/0D2esmG5upUZiUY10cuy0w9
u2D0CqCAebNBSOuGzrBazp0+eu2daxfifDxYf7GLZmFWIXo8Pyci9C6NnbgwtVor
yvYwVhyVbtk6yDws8S+v
=h/k1
-----END PGP SIGNATURE-----

--rYkcoROieYsUh8uu--
