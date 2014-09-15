Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaIORCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 13:02:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43169 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaIORCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 13:02:32 -0400
Date: Mon, 15 Sep 2014 09:59:23 -0700
From: Mark Brown <broonie@kernel.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Message-ID: <20140915165923.GX7960@sirena.org.uk>
References: <1410722585-13393-1-git-send-email-heiko@sntech.de>
 <1410722585-13393-3-git-send-email-heiko@sntech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wrIrAujhz1F5gxq3"
Content-Disposition: inline
In-Reply-To: <1410722585-13393-3-git-send-email-heiko@sntech.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] regulator: fan53555: set regulator name from
 constraints name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wrIrAujhz1F5gxq3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 14, 2014 at 09:23:02PM +0200, Heiko Stuebner wrote:
> There is a high potential of more than one of those regulators existing
> on a board, so name the regulator according to the name provided in the
> initdata instead of statically.

No, this is pointless and broken.  The core will already use the
board-specific name to identify the regulator in diagnostics and so on,
the name being supplied here is supposed to describe the regulator
within the device.

--wrIrAujhz1F5gxq3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUFxrqAAoJECTWi3JdVIfQzfwH/2THG1fWlx5WPGsHDi4hXyae
O/ZkOGHFyNPOdGnb+bvR1+bzu4uQAd15eeWbQXkVwdaEsLw/kA18J4NWKLqGwPvC
24+mrd3VV5ezCEjRe2rDc8r9kXHnT1vZfSD6LndynT6v/HusqfyoLk4L26CyeNsA
iPj5uw5PQRc5DRnhrs0EZ8OwGN9Nuk568V/VXE944CkT4v4A2rrlfNPcH5BszTAu
PXVEqGEZInoB6fUv7NFnzYejhn01jCIu6kxKCV0mmNUEf/jIXju1nL6AcmHqMC8O
ZgsiAtp/bBT13TrLcJFEOIzu6A9P5lY8THMBQjHsL3xA4wDClxXJBL+AM/IGSDo=
=A0yt
-----END PGP SIGNATURE-----

--wrIrAujhz1F5gxq3--
