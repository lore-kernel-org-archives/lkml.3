Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaKYWrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:47:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38764 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaKYWrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:47:52 -0500
Date: Tue, 25 Nov 2014 22:45:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Ben Zhang <benzh@chromium.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Duncan Laurie <dlaurie@google.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        Flove <flove@realtek.com>, Al Stone <al.stone@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20141125224532.GC7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
 <2580837.YI0IvfXqRR@vostro.rjw.lan>
 <20141125202722.GA25261@sirena.org.uk>
 <1926483.B4ieFnCBlM@vostro.rjw.lan>
 <CAOV7By+7g19p_-4R-sSM_2q04fKCmOq3um+S_L=5z=T5SVdwAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F20q8ig/xCX9TrYX"
Content-Disposition: inline
In-Reply-To: <CAOV7By+7g19p_-4R-sSM_2q04fKCmOq3um+S_L=5z=T5SVdwAw@mail.gmail.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F20q8ig/xCX9TrYX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2014 at 02:41:28PM -0800, Ben Zhang wrote:
> +Duncan who works on our firmware project.
>=20
> Please correct me if I'm wrong. Here is the summary of what I understand.=
 Looks
> like the recommended practice for passing device platform data is using _=
DSD and
> the new device_property_read_ API from include/linux/property.h

Your understanding matches mine here.  Doesn't mean I'm not confused
though!

--F20q8ig/xCX9TrYX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdQaLAAoJECTWi3JdVIfQl0EH/3AKlhqcvDyf2DjalUSe3SAq
tMgxU5n4Ai6ssi7O27uT1tBI9xttDhSoHYtjYmOwoPh66xwBIeXvqqyU9oOaSdZC
oPr3MXb7QxOUKqQXIA5s/O0MlHXtazC1o6TDtwZXmLo0VQaw2/h4CbidaJNPJD5O
DJyRswWK5S5SrDKob5Y2kkMgjFAJ83UeFv5UQMS5yB8ypkEdooP5bQ2TW0xPbcrD
WatgFZJKVqMhXOpbilmgOuESamazwtB08BkTZpDvoudpFUmhABetm7nt8ozNlv0h
fhV/oALVaL32UVfGSdolz87odfm/Rqu6SxBd8yhwb44sAlVMw1djI1u9tjclmT4=
=SPwo
-----END PGP SIGNATURE-----

--F20q8ig/xCX9TrYX--
