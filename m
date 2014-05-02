Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaEBQ4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:56:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55335 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaEBQ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:56:04 -0400
Date: Fri, 2 May 2014 09:55:46 -0700
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Message-ID: <20140502165546.GP3245@sirena.org.uk>
References: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140429183758.GH15125@sirena.org.uk>
 <20140430180609.GC3000@lukather>
 <20140501011811.GF3245@sirena.org.uk>
 <20140501223629.GJ3000@lukather>
 <CAMuHMdUWa1_n94sDvv=L_goc+SOnD9CAKi5DzifrY7GWYRdQmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QzTImLEHWgBoPYMi"
Content-Disposition: inline
In-Reply-To: <CAMuHMdUWa1_n94sDvv=L_goc+SOnD9CAKi5DzifrY7GWYRdQmw@mail.gmail.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Force the registration of the spidev devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QzTImLEHWgBoPYMi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 02, 2014 at 01:28:26AM +0200, Geert Uytterhoeven wrote:

> And then you want spidev to bind to it. Would it help if DT offered a feature
> to add a compatible entry to a driver at runtime, cfr.
> /sys/bus/pci/drivers/.../new_id on PCI?

Yes, that's what I'd been under the impression that the bind file did -
allowed modification of the list of devices to bind.

--QzTImLEHWgBoPYMi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTY84PAAoJELSic+t+oim99qAP/1G1pCv1j12jRAdOuTxiwDKz
UPlaDgRSOyKe/FcrGPVVp5LzXp/Ix7diTeTay3/iMcOIloD33UR272cUC9UipliH
0N1ATpF4TQ6ird6UZPhKwFkrcWrsQwyZ1aw0LJUtCNhp9M6pZIf09FhVwwe1XQ3a
Vrsyu5OeS0EB5U+jfMKcNiEZLGmK3E+xhZTeXQ/OYbv2Y5UP3QdxMzpAWyb+ZBMk
sd8v4x71keqXrquP9FaD7gsFA346qtjMPuVKIcIflhhzaSt3FJBHty6abKTTSVzb
rlsu4jgY5dRDsVTTYOBxw0PhbxVmi7zwNMwrE33c3t5rH2E9tbvrmIfHZhCOihCe
P81geH9Z+HsHFoFlqyq1vgM2aDSOt6VlXxlEAIBj7pS7MIusoV7fbNm1ydGoUoTj
bw//FCpvvr5XXjoV3TYRY3OalG1IyYo29Nvy1fFOeYl1x+7J6GwXHuaEDdLJKPsN
uV1FzcGUQNLFfcGUbPOGU060JTWknsIdnzc0Pf0GfoP5hi1j0XFFdymxpyuUQkZM
2yvW2NsRnZpN5vE5ud36vmvJ02FRZ9mFhhY6WA1WMT3/NyRR1UnKStZB3F0S7bgy
LhjEr0WYMhhgp4mwBhOrfAc1dR2eLj5RcRLTJSK51eCzGla1++1gCQumSBDpwlnf
WJAS0tx+YoUejbMMDSut
=2Spb
-----END PGP SIGNATURE-----

--QzTImLEHWgBoPYMi--
