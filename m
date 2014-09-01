Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaIAKtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:49:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44435 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaIAKtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:49:02 -0400
Date: Mon, 1 Sep 2014 11:48:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140901104845.GQ29327@sirena.org.uk>
References: <1409512253-15738-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5ltdm4mkXNgScZ66"
Content-Disposition: inline
In-Reply-To: <1409512253-15738-1-git-send-email-robert.jarzmik@free.fr>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 RESEND 1/2] regulator: max1586 add device-tree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5ltdm4mkXNgScZ66
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 31, 2014 at 09:10:51PM +0200, Robert Jarzmik wrote:
> Add device-tree support to max1586.
> The driver can still be used with the legacy platform data, or the new
> device-tree way.

Applied both, thanks.  JFTR the reason this got resent is that the
original went to my Wolfson address.

--5ltdm4mkXNgScZ66
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBE8JAAoJELSic+t+oim9XbMP/1h2fME4bBf+5JbLLeg3zEiE
VFeccObPlwtptNH04m/E5mfZ7P6vaMgTcmEiNR2zTcems4g0KxIprw1YQjkFC5st
y2Yf+RRnEOh/DPBWwhc6iKJc/xLGeTqKCn4rlDRiOkrEQNFFWBGjV4BJk3ypzMFR
9DhebF2q+3wsc1LFU7UVwjauH7V0V6tEx5RVqt2+quOI90F3yFhGIF0Y4+R5XWNq
p8UrdIHRHYse3Dm8PqcV7OlQp/QYY+eXIDMT/QYmXxCMbZHMtAnopL/rlIAQEl12
1PW+RTI+blqoOBaFAi3YTmxTbUKUARet+fV5cFi6rbeyLKMpngVcVsFKgvI4DYl0
xmf7cTq5IrSSTyzMIblT30XvnoPou0OXWSgnKyfQT58lwBNbBggLu6UWwBhaVT5d
8Rdpn7ARMBbGy2S0O9uFXMxJHmTdkpIlnsccQCcWr/kzk/FXLJEK+JHTGh+UgkHN
j8FNBg5bpiIFj7U4uOEprMdghEsnhL6cfiOa7rqHJkptetQvrJhQfh5r/KdfDriO
u2mOxEQGZlkv1cHuXkTX84IAK+DSHw+HEv4hxfS4px2COoXCHQic96aP6/oXkjqN
jHOfWCuGfAkbDQcIFKyDMV8/4FG9iHmELaq2jpsXS4DIwqCZF9qux/7tH6pdTUkk
14UgGlXBlcWbOz5+T7nG
=XyuY
-----END PGP SIGNATURE-----

--5ltdm4mkXNgScZ66--
