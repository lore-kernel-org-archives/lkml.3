Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab3A1Egu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:36:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49891 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab3A1Egs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:36:48 -0500
Date: Mon, 28 Jan 2013 05:36:42 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Seth Heasley <seth.heasley@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>
Subject: Re: [PATCH 3/3] i2c-i801: SMBus patch for Intel Avoton DeviceIDs
Message-ID: <20130128043642.GA30953@pengutronix.de>
References: <1359144661-3528-1-git-send-email-seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <1359144661-3528-1-git-send-email-seth.heasley@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> @@ -166,6 +167,7 @@
>  #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
>  #define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS	0x8c22
>  #define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS	0x9c22
> +#define PCI_DEVICE_ID_INTEL_AVOTON_SMBUS	0x1f3c

This seems to be sorted, please stick to that.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEGAFoACgkQD27XaX1/VRsYhQCgtOqoxm+RS5rCMegU9ytv7dfE
GfoAoIhnFLkWTVR2B7uqWSE/c3PDGaag
=SEiG
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
