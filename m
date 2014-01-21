Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbaAUSVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:21:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57667 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbaAUSVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:21:35 -0500
Date: Tue, 21 Jan 2014 18:21:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140121182130.GM17314@sirena.org.uk>
References: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
 <1390317009-8292-4-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QvYscaK3qHF14stx"
Content-Disposition: inline
In-Reply-To: <1390317009-8292-4-git-send-email-geert@linux-m68k.org>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] spi: Check that Quad/Dual is half duplex
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QvYscaK3qHF14stx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2014 at 04:10:08PM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> Quad and Dual SPI Transfers use all available data lines (incl. MOSI/MISO=
),
> hence they must be half duplex. Add a check that verify that.

This is surprising to me - I had expected that there would be extra
signals that would be used for these modes, not that the opposite
direction data line would be one of the ones being reused.  On the other
hand if this is what all the flash chips do then it would seem
reasonable that controllers do the same.  Can you clarify please?

--QvYscaK3qHF14stx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3rqnAAoJELSic+t+oim9+sQQAJYLmkPiu2NJ3T3BGIkzJs3j
yi5O8Vi0yNjx+PIh6H/LVcqhCrIUEgWQqg1wM0YidxUkc2Z/GP7VEM4tocitVkky
TloJvedbxDLd4J6iXitSvomSG+4xc5MjkTUCP1rSS58vj0hB1b1xEdOAwyw6knMK
OlOhPyfZsjW9CzfLiUhS7Bull7qmclefBLZqYDlpSuuVk6VMB6mWrn8svHrPBEn1
jQ+pAJRlECEXjktPmRB6q2jxF/C17VFrHy7D+E8R648lZvnbT67NbEDdsYCBzom+
krYqAjpjtV+fMUOOQhV3DDv0oWxDVfqOfzCINHwC3vxq/XMMpNTjC1BBuxSmWdhD
2VA2DARnXIos0VuxgK7naBHI+qzWsdwDPGeas0kNbKxR3+AmhAtRAnINtTDjMN3d
FkNezKkwP8IOI8qGtkabJUTs/THjE5p/uoUWezN/e//wVOhIOb9gRPxQYg4kz70F
BfZEd7E1r38oo6TPqd2X0X8nxeOUfe58S+ZVVX/5P7Gw3pXXFBk/ABqpoxOiFkGZ
Bta7rkyrAWnHX5HSm/FpiTSYSflP58P4jbnV11uIXriKwExdnHOJWI8liWjZW4DC
7fHvQG+ziEVs77ULSjjUfUU8J4ee9nSpbgAfxgmQjm8BFQJN7ELheJfXHILWHUsP
MalsosmQxaOWsC+523aP
=g917
-----END PGP SIGNATURE-----

--QvYscaK3qHF14stx--
