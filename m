Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbaIOW1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:27:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43815 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758760AbaIOW1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:27:13 -0400
Date: Mon, 15 Sep 2014 15:27:06 -0700
From: Mark Brown <broonie@kernel.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Message-ID: <20140915222706.GD7960@sirena.org.uk>
References: <1410722585-13393-1-git-send-email-heiko@sntech.de>
 <1410722585-13393-6-git-send-email-heiko@sntech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z7ir0bSQfJ1ZTyo9"
Content-Disposition: inline
In-Reply-To: <1410722585-13393-6-git-send-email-heiko@sntech.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] regulator: fan53555: add support for Silergy SYR82x
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z7ir0bSQfJ1ZTyo9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 14, 2014 at 09:23:05PM +0200, Heiko Stuebner wrote:
> Silergy SYR82x regulators share the exact same functionality and register layout
> as the Fairchild FAN53555 regulators. Therefore extend the driver to add
> support for them.

This seems OK but depends on the previous patches.

--z7ir0bSQfJ1ZTyo9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUF2e5AAoJECTWi3JdVIfQOx4H/iPIQxjS/XxDDWepNK55C1Bv
SNBJSJttGJQ+dckT4qRUxdmHXvLMFvm0Y8r0t/PNf8wv/9pyOPs3RY0WpgXvsQL8
PraJxInJBElkqOT04PZmDMxlWMTVoj/7QJ3bWo1UA+L58mf74BwjgkTFeSGssujH
CGtMa2wm0orhx2GAXW/dr3OIL79TIJ1FhYXcQ6vKJQIAAcGsZBNL3412YgF1W2Eb
6WcHAHWMh1q0NcIlXsG6HtGCTnAfHaV89YhMD/0e0ycZy8aFky22gBFt1GyPIa5A
X6geTq8QHN7gYT4O6wjvFvEXB3Fh9rBHurVZo2YOjwelPtQuKTY5svPAqb3wR2A=
=uIBk
-----END PGP SIGNATURE-----

--z7ir0bSQfJ1ZTyo9--
