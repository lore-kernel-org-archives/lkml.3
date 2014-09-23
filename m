Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbaIWTFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:05:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32782 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753287AbaIWTFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:05:05 -0400
Date: Tue, 23 Sep 2014 21:00:57 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: wsa@the-dreams.de, jdelvare@suse.de, arnd@arndb.de, dianders@chromium.org,
        u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, maxime.coquelin@st.com,
        andrew@lunn.ch, sjg@chromium.org, markus.mayer@linaro.org,
        ch.naveen@samsung.com, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        chiau.ee.chew@intel.com, christian.ruppert@abilis.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH V2] i2c-designware: Add Intel Baytrail PMIC I2C bus
 support
Message-ID: <20140923190057.GN15315@lukather>
References: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
 <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zbynv6TNPa9FrOf6"
Content-Disposition: inline
In-Reply-To: <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zbynv6TNPa9FrOf6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Tue, Sep 23, 2014 at 11:40:26AM -0700, David E. Box wrote:
> This patch implements an I2C bus sharing mechanism between the host and p=
latform
> hardware on select Intel BayTrail SoC platforms using the X-Powers AXP288=
 PMIC.
>=20
> On these platforms access to the PMIC must be shared with platform hardwa=
re. The
> hardware unit assumes full control of the I2C bus and the host must reque=
st
> access through a special semaphore. Hardware control of the bus also make=
s it
> necessary to disable runtime pm to avoid interfering with hardware transa=
ctions.
>=20
> Signed-off-by: David E. Box <david.e.box@linux.intel.com>

Sorry for stepping in like this without really knowing your platform,
but wouldn't using the hwspinlock framework make more sense than
hardcoding your own internal functions here?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Zbynv6TNPa9FrOf6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIcNpAAoJEBx+YmzsjxAgmswP/37hLAseGbTf5X4Q6vIh2CmL
KxVdN52qzQ0uLGvR+DjMmT1kf1vObh+tpRWlmZ7bCr2IalimE1Miy27z0I+scr9z
+JF4N0q1hXClABPdmu98ddO9WwLXgxWSKRE/I1oW9YK8DpaiMZ0TCnUrArUZ4RlG
L1for5ITmDAXzvcEhp/4i0fz9amR6J6zwhQUkLrOLY8lJWTr3DCPyR8vhmkmO2oo
x9RVAJS7A2cPrEMXxIi3PSznXMEsqGz0PY4cizFyz07yvwcJWrB2PuoY/Mnmp/vo
SX3pWbWwRN7cK/tGubG1O7INPTg9FBMsrjJzdRyYZGxs+Gi99L32/baG5zgkwvrJ
xt+glQQrx2R6zL9VHi8EX7o7p09tPzKSLBDB5UdGv17FnIZtGOOUAZxkpOhr+OtP
OPoWrN4YDM5ayJmt0gdnFf/A0dRIvTlIU4jlxk7jVJzNZRDEV77/E/k7mIJITwvU
OHZDkMsJAXByvIAnlZvXnNtRq7m3uohHLsWBeaNnz3ScdaJu4xY0w1gWJwokSlDe
3qBMMgDFIIqLgbtRpPhNw1v1mRncAzITPqd6KoEF8lrOdzoL2n75eWBeJeI7DOm9
b0RzI266Yw1d5WNGDG67UFRvULLJLwnntVsV3Xcd7SlT91yzQZrh75YBBr72AAEx
Gbo3jDcOReBMDYyzgxAQ
=qdoH
-----END PGP SIGNATURE-----

--Zbynv6TNPa9FrOf6--
