Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaHPWU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 18:20:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39196 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaHPWUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 18:20:25 -0400
Date: Sat, 16 Aug 2014 17:20:06 -0500
From: Mark Brown <broonie@kernel.org>
To: chiau.ee.chew@intel.com
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>, chiauee85@gmail.com
Message-ID: <20140816222006.GB14537@sirena.org.uk>
References: <1406221854-12828-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
In-Reply-To: <1406221854-12828-1-git-send-email-chiau.ee.chew@intel.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi/pxa2xx-pci: Add common clock framework support in
 PCI glue layer
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 01:10:54AM +0800, chiau.ee.chew@intel.com wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
>=20
> SPI PXA2XX core layer has dependency on common clock framework
> to obtain information on host supported clock rate. Thus, we
> setup the clock device in the PCI glue layer to enable PCI mode
> host pass in the clock rate information.

Applied, thanks.

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT79kTAAoJELSic+t+oim9JxAQAIVhzet03FzoVmvW9DMgIE1U
KYa/40PFVVhdAyu9teEHw7T21Jzv8GMVw6MRRnelVYHpuLiDiabO6SzkzwfZizcw
R042exNpSMT6TNT1zOffN0q9N3x8Hgkw66P50yC3eYIp4c9tNBVaB5dJq1MqlP0R
ZQiFRhH32KB/EWoR/RZUBFU3nurftreNpOiI+WzOP3Ohyqw7HcKwlQ8g24Rtmule
AhUCLe0WN0BKxbvBGwb+uemSOBlqsBUDt3fhXr95PJcroWgxjYhOD65mfC/n8D4l
dwNd0vz0dtT7uvu6EZ8Y9O1T6jMshE6HKpLYfNckuSN/s09HjLEbjOtF7pL+pyfR
DmPWlEXWL3lt7OUUlbz4PDOf5pe4l1r75UYjGLBSx80+nYaD5uQl4bS7VrDGiBIX
l3GV+X7+7ME+KHwwrU+T+UgmV8kc8azl0dk9DwcHa53XsR85VHzzm96NrWu8G4HD
UC3zLh6ccHOXCv5dxLo0X6vzh3d9KZFDeYlv71X5+yrm7HH7zYVeUYDgaUUX5IyD
t3YR2Gcts7p8peGnA4/ZeDdr7hJdv4HZ1e0a3jXcs98jUmFUiaDAJ0+U00DUsjVi
lG5GgmB7JOoYuxcTxVIPOC2VrWGVpyNuhZKO9JmS/eODUDkT1vUb2qcNfUNwv8od
zicc8iq3w2S45fmtdDE+
=7buL
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
