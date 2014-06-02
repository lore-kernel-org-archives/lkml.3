Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaFBMhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:37:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50842 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaFBMho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:37:44 -0400
Date: Mon, 2 Jun 2014 13:36:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20140602123647.GC31751@sirena.org.uk>
References: <1401738379-4107-1-git-send-email-chiau.ee.chew@intel.com>
 <1401738379-4107-3-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
Content-Disposition: inline
In-Reply-To: <1401738379-4107-3-git-send-email-chiau.ee.chew@intel.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.174
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] clkdev: Export clk_register_clkdev
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 03:46:19AM +0800, Chew Chiau Ee wrote:

> From: Darren Hart <dvhart@linux.intel.com>
>=20
> Allow spi-pxa2xx-pci with common clock framework support to build as a
> module by exporting clk_register_clkdev.
>=20
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Reviewed-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Oh, and I just noticed - you need to supply a Signed-off-by for any
patches you are submitting, please see Documentation/SubmittingPatches,
this is required for legal reasons.

--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjG/cAAoJELSic+t+oim9UzIP/jkQrPeEYE8Nicx8rDGldQL2
zgC8LxxhwWdKwiS8qAbVlP7I5Cm7RNEZf4URaLja1jtXSZokQcF3xrHN+LNjEctK
uMk8xStT9g5xieGIFEKQ4cHM/TgsGQagm13kDw6QR9mKDyiApec4ICt/m/QjTwJO
VaXHnRW5VmWt+D2zeg+UkNQt6OUsCKoyw33SmBYdpnXYiyky/mebBfBXAuJJIoSs
QHeKXizdgXNtHsjJ1YUmMCvrGeZOMn8fvx32Mrkwa6DzIekacGw1ZnCBeesTa1U5
Oh8DFbMROwuJSOZPXgMSpGqggrIQOIrLDWQwnLBcqu8oL+npXChkjCrr3o+5p1rV
A6heFuxKwztmuDSZ/bGL6C9kFxQdHTZo/1OZJH1G4q6fmatjauNWTdlKo8kOErR/
FYA/U+KWAb3Tw1AnQazbKTyLMOJBtvcQzHSJmePro/M/ZjhxIAXGdRQ8IzKKmNvX
IHjOo/swdK4yU4DJsf8Fpie1og1SKx5bW1ppRkCeawd0yLDuThE7ID7cOWm45kcI
cED0/YttzEySVMdpo1QaY/mV1WcQHyUa56TpoFQmL/vDEAp7RzTrqZn+o8YQGEar
ectK5bDLmmQT2xkwMPK5myimmK/9G4p5zep09oNBU7mA6v9wEQ/ZcoSfFKG0+6QJ
ivn/DmK4rTg6ZOCriv07
=48ru
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--
