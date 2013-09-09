Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3IIQTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:19:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59039 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3IIQTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:19:34 -0400
Date: Mon, 9 Sep 2013 17:19:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Lars Poeschel <poeschel@lemonage.de>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Message-ID: <20130909161924.GT29403@sirena.org.uk>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de>
 <1521079.WSLhhfqBXl@lem-wkst-02>
 <52261BF0.4090106@wwwdotorg.org>
 <3144247.j2q6H0KWZx@lem-wkst-02>
 <52279524.8090006@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AAsCVVzXF7rH55eG"
Content-Disposition: inline
In-Reply-To: <52279524.8090006@wwwdotorg.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AAsCVVzXF7rH55eG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2013 at 02:16:36PM -0600, Stephen Warren wrote:
> On 09/04/2013 03:05 AM, Lars Poeschel wrote:

> > The driver that tries to use the GPIO requested by this patch before HA=
S to=20
> > fail. This is exactly the intention of this patch. We don't want the GP=
IO to=20
> > be requested any more, if it is used as an interrupt pin.

> That will break existing drivers. There are drivers that request the
> same GPIO and IRQ. IIRC, the SDHCI CD (Card Detect) GPIO is requested
> that way.

Yes, plus input devices and audio jack detection among others.  This
pattern is very common if the GPIO is actually being used as a GPIO, an
edge triggered interrupt is used to flag when something happens and the
state is determined by reading the GPIO state (often with some
debounce).

--AAsCVVzXF7rH55eG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLfUJAAoJELSic+t+oim92TEP/12eEMQvYJY2YP8SABmfjV13
5Eh6w09weaXRuDaBrhJL3ZsR+hUlf20Xo4g9885MybhOFkGaDsfp/ArMEqkUTM3v
vrfyH7IEUh9fL8hNRJwQr198umth0YnKQFN5AXP0XocWPgAv5l0Qw9dZHNvpQ0Dm
d1Re7CxUHasCdGnshVjfSEFVgUBARa0AZ1LN5pwZo3GqVFdPpIQpJ1uwa3DGDtWF
xH5+ccVecLaDdwVH3RvIeeKOG0NPpzboUotJE3/rMUtdIAFGR6ZWYq391NzjMH4f
GgaJ361JaFJI3oJj8TT31S9AVLNJ9PZGxLU4OXn7MvNqYdTwXLtFvYOJ47zpwQ+X
ZYp+8lPQUMIJ8SXVsFFhsbPDaBTtdY2fXPKMT/QT45lwpVSdgv+zn6AShTwnyKv9
KrhpJlwW+qgQRJuv+FYzX3HUbzWI/rcQHNT5PkkT233gW/OpWWbSsOFmAHGdy0ZT
tvDzQ5ZZ7bhGxCvivf1gQK4D3labD/UEF3dcLhoBMd/1F91/JOetckKULx1OFI06
50Jck/msRsh3NpM3c+mtXQJoBKS+PZEvOt/yHqgvrcfcmj4RR/sxG7o3T7KCKQ50
I15wD2X7wGHge2LO92+x00fojsz2UXyRINph5Rp9mQcamfQOKdOTxSi2QqPok/Tw
NLY9muYN6pt5AsEZQCn8
=Gq+Y
-----END PGP SIGNATURE-----

--AAsCVVzXF7rH55eG--
