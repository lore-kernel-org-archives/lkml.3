Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965654Ab3DRD4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 23:56:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50978 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965536Ab3DRD4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 23:56:46 -0400
Date: Thu, 18 Apr 2013 06:56:10 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sylvain Munaut <tnt@246tNt.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [RFT/PATCH 2/6] driver: serial: mpc52xx_uart: Remove
 "uart_console" defintion
Message-ID: <20130418035610.GA18349@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>
 <1366198467-6757-3-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <1366198467-6757-3-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2013 at 05:04:23PM +0530, Sourav Poddar wrote:
> Since "uart_console" definition is now moved to serial core
> haeder file . Serial drivers need not define them.
>=20
> Cc: Sylvain Munaut <tnt@246tNt.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Rajendra nayak <rnayak@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>

looks like it should be merged with previous patch to avoid redefinition
errors.

--=20
balbi

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRb27aAAoJEIaOsuA1yqREqM0P/iUI2YrhnUH30OFCIsOYyVbT
IiNHMkNlFk376CeQAN2zQp3zw9IKdWIEyEnkGVgX4ENlz7vPLOSyJp/wx0wM5M5+
w/lSZlhNBwkcZs22aFUFWnW1cQF3QkhR1VKRpMbF+e62sMFMRX2gS32G1yjRsKmS
PhBBMtJeVDMEXxBHH6fLAk5+Qg1cwUhFQj9j/XOLIa7uVGc5vBlIrQMQy11P8grl
JmOL81fwPiecjDx5BaLeQDW5k/LVbj8ZikmmW32cE5ERpJrJsNrB/Ogwv0MSMi4I
C9SY2mKMzeAtDSPDTMpNAfLlyafrnF/nlCl40kIVzn4CPvSZP7ijOh7WAUN2RQlb
MVd/9M/2TV++TSZ53oYRFb9ZjS92bCzoQZwRh7WdPHWiIQHGdz/aMjL3vzdbNUHa
caAFt2Z+UavfpzbyiWUIOvx4dibi2KAZWc1w1x7G+HlbZa2WBdfkNQAk0RHoIKLS
+s4GqiOV7E/zXhE4OwCvTkvmir+eMJ3VO6+E8rTYxhSJj9aSxm4IdDvHrNi7a6Rx
6I5r4YQY+RIAKdggtknezHG/ttwHNLWz9er0zAx6ZLEhFTUaAnra9tefFHi345kZ
AYtFIrS+xq9KPm2FO5HmRhYaQs8iufpfoJbMpPjffILVvMIFHwUwnTDtPa/32CmC
Wwzp5Ngc/ihy6vdAgMT0
=uywt
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
