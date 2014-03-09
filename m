Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaCIIgW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:36:22 -0400
Received: from sauhun.de ([89.238.76.85]:60467 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbaCIIgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:36:20 -0400
Date: Sun, 9 Mar 2014 09:36:17 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: designware-pci: Add Baytrail PCI IDs
Message-ID: <20140309083617.GB2579@katana>
References: <1392819029-6438-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <1392819029-6438-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2014 at 04:10:29PM +0200, Mika Westerberg wrote:
> Intel Baytrail I2C controllers can be enumerated from PCI as well as from
> ACPI. In order to support this add the Baytrail PCI IDs to the driver.
>=20
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied to for-next, thanks!


--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHCgBAAoJEBQN5MwUoCm21YUP/ikOPasKIk4Yv50sDIBFHGyd
eiKa2ClwKCyLFlUVEtTjzw4Hl1AO2c2KaFHIEh1zBJAnnH5UOuTAbNrLwhO3F4om
wkSpX33ObmqyZA6IYnHcTZo7wYWMHyGlvtAC6/qHHD/W+iKcUgjMAXlSrOQyHiqI
IWv7IYfJxTfS0KQnb9x16niByu+MA1sRGDXtDqp+Q+yokC37ub36mVw4IePribcq
FCP3ZYHbAtf8iPTTmtgnncs23hI5f8DxDzdSytv+v/A1seULQBsM4QpsqSUuVDLM
Eup7alUQw7C28BJiaXVreL0OUxgiHVMB+m/K2M6PvRRytaqOSzOoj662Yb+izTw1
5B3eVRsvYaabQsznRbgB6lWWvW6nfYb+txMRg+9GdztoPHQ4IpM4Bqw9EkldK23K
5Az4KZIvbhgXHL/2vFjg3soUlxkYYRA0RbHEfhn290cHj4TB5cRdbJv+jSA50KWp
VSVercjB9J9Bi4M53XIhEtYhnIvLqLPHPuUKi7Bew5yN4FE/cI80DnbOgigvuwTD
cRyx+MDFXhhkYW/s2bEDnnEOdV7KWebNyer0vQRc2TI4II9f4i0/20adyGGnUHDi
g8SxtbnZPcD+4Vj3f/P6rwP6BY8kjdQXLdx5R3yiV2HtV67mdxTrcXMgl4pffw2y
OkXesh6bI0CEVHhol3yL
=sePw
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
