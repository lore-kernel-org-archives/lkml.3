Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3G1Mvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 08:51:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36687 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab3G1Mvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 08:51:35 -0400
Date: Sun, 28 Jul 2013 13:51:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Message-ID: <20130728125111.GW9858@sirena.org.uk>
References: <1374773943-7454-1-git-send-email-p.zabel@pengutronix.de>
 <1374773943-7454-3-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jaPd8mitbVMxGCA+"
Content-Disposition: inline
In-Reply-To: <1374773943-7454-3-git-send-email-p.zabel@pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] regulator: Add Dialog DA9063 voltage regulators
 support.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jaPd8mitbVMxGCA+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 07:39:03PM +0200, Philipp Zabel wrote:

>  - 1x power switch to switch on/off 32 KHz oscilator output (32K_OUT).

The driver looks good except this should be implemented using the clock
API not the regulator API - some drivers did this while we didn't have a
clock API but we do now and in any case the clock shouldn't appear as a
regulator in the DT bindings.

--jaPd8mitbVMxGCA+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9RO8AAoJELSic+t+oim9pdIP+QFRHrjmL3jSauFoaKHzjTys
ZIIdbPN4zyVvwPLZUVMi3Nn1L9ZswHuLd4/POwt5WJF1+yFAm9H6soIbyZwAmY5b
f3f3K+2SkR58RwGQVXb/VIrx5E1WTGR2L+a+/7VmFzL71QShcN2e8y/6m4uubI4d
jd/OxJ/Ozx/Xdjl14pZq10KBUv4uwVUM+Mvv8vcFT5Prx1eFotbIfDRNw3DlRAcT
SGgB/h5nOwwpS2QmcZk+g1LBSSaPwBRHFmJtVsHNXV6daswAVFIkxGVfgsbSpvj1
dc3vgX65pB5D1+BgQjdoP3GVcOQ9uBKFLPApuJxS7qh4Rp5cG5ve75IZtSMHQfrr
+VWVp5loPB/VAPASCEQHHb/Xm0oIwyqycwQQhBCoyvm6Wq2LMtrOo2XZRqEUrIWY
um0OhUco/ujfxVwHEsdHBir/kusP/FF+LEDsCKm/hSXOMWAjU74EfaoOKCv8R/gd
vJEdXfHSibAqWTEHwNXw/T3LNB4Vhb3HAIDWubn7OBZEOwBeIOSntDigRsamjcm0
aVzAmoQfAACn6MOleDlqeosa1k+GfvmMIeTFi74RxbO66ApP0w0yJQ9fBM69ePgT
jbqQHh4wtVxbJErKPKjVMxaWlDGFBzTUhclS29dOTXXVk+1mswcdyj88ER0yAlvv
L1uMhzX1uDnPMhR4AC4K
=IcJr
-----END PGP SIGNATURE-----

--jaPd8mitbVMxGCA+--
