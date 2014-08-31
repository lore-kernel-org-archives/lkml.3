Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaHaNFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 09:05:33 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43116 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaHaNFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 09:05:32 -0400
Date: Sun, 31 Aug 2014 14:05:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140831130516.GH29327@sirena.org.uk>
References: <1409328631-1420-1-git-send-email-geert@linux-m68k.org>
 <20140829173752.GX29327@sirena.org.uk>
 <CAMuHMdW3RBxXNrfK=2d_uHCesE+NaLFheGgdBEP7JuPcd8Xd1Q@mail.gmail.com>
 <CAMuHMdXqFSv9B-OuGYGBfb5NReLQNRJat5_9=uBdSct7_3sQOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NncV4Eud7lVzK4Rv"
Content-Disposition: inline
In-Reply-To: <CAMuHMdXqFSv9B-OuGYGBfb5NReLQNRJat5_9=uBdSct7_3sQOg@mail.gmail.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi/drivers: Restrict COMPILE_TEST by HAS_DMA where
 needed
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NncV4Eud7lVzK4Rv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 31, 2014 at 10:39:09AM +0200, Geert Uytterhoeven wrote:
> On Fri, Aug 29, 2014 at 9:13 PM, Geert Uytterhoeven

> >> I'm wondering if it isn't better to have the non-DMA platforms define
> >> stub (always error) DMA functions instead - it's less error prone and
> >> with SPI there's a bunch of drivers which can run perfectly usefully
> >> without DMA while optionally supporting DMA.

> > The SPI problem will sort itself out once all SPI master drivers have been
> > converted to use the SPI DMA core ;-)

> BTW, the dmaengine API has stubs, only the low-level dma-mapping API
> doesn't. That's why e.g. spi-rspi doesn't need a dependency on HAS_DMA.
> So it's indeed a good thing to handle the low-level DMA mapping in the
> subsystem's core, as only that part can be optional and depend on HAS_DMA.

Yeah, but I'd expect there's other subsystems which will be in a similar
boat here and with dmaengine having stubs it seems strange that the
mapping API doesn't.

--NncV4Eud7lVzK4Rv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUAx2JAAoJELSic+t+oim9rc0P/i7Dm0TqbBvt2WbfUyImsHoo
WyUNTqyw3WacLp/zIR+4Ya5OvnceOI7QRCx+96wFo92zc8dp98OENoOaFdKm6tPy
4yj8oa58X/Fx53xtjY8IbjEwwi8s3yqTR/4RwgLlV0funP5r2bZs6WX3gCq42Y+m
fE8LA6GffXQGgRY56VR/G/eGbQ0LEkhzIZBNBzDgvYtyf9aN+Jrja4t1oIp0m3q7
O5T/Fhps6mav/TUJxSZLwopp+RqflrFPeXdt/5QKmKkpUt3pNkqXBtAR80UkyfHd
Oij+MmGVOTKyHl3lR+29w7L6bTqT1u5zcnTSTOeMGsHlcVwfph5wnjLqnics9pLJ
ErtnDungvFYfoixdf5IIW/swBjorBZaYnfWqKq1EK3qQvDFMiR+e3dBWDRmD8jPY
+dcJq6cV/WYoOdXZTXL44pO6BKDKOnX3tJwTY9BpfFSpb9V/2wMtQcGFFo1Cm+16
4AWZLQhYKavTmUbPKzPFi/1QlKeU99hVCur2O5Hp/1yIErWthi8QTXTaVf73rZIb
yUs1u6YZ+hFearGCyHMNae7liwuPzvr2F1jeIvx88O5bU6Y6jIRt25M5qBG2u3Im
sUjhxORArsgnKtLE3wRF6uzCYecM12XcHlYZeApRUYgzfNERspu5Hvxs1z2OaY8t
XO/6Bj3TP7t8ZqstGzrA
=R0s/
-----END PGP SIGNATURE-----

--NncV4Eud7lVzK4Rv--
