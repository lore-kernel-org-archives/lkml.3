Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab3DANny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:43:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49484 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757595Ab3DANnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:43:53 -0400
Date: Mon, 1 Apr 2013 14:43:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        richard.genoud@gmail.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 05/14] spi/spi-atmel: status information passed
 through controller data
Message-ID: <20130401134350.GX18636@opensource.wolfsonmicro.com>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
 <1363679101-3834-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NAuYj0K7Umiq33rm"
Content-Disposition: inline
In-Reply-To: <1363679101-3834-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NAuYj0K7Umiq33rm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2013 at 03:45:01PM +0800, Wenyou Yang wrote:
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
>=20
> The status of transfer is stored in controller data structure
> so that it can be used not only by atmel_spi_msg_done() function.
> This will be useful for upcoming dmaengine enabled driver.

Applied, thanks.

--NAuYj0K7Umiq33rm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWY8QAAoJELSic+t+oim9Wz8P/jrlA/TjQ8b92bZhLp7rESwP
CzmjmFfXO+DPHT4DtaqRWDyH8PkEUAvn1LXWWOsE82JjbnmDRjXSsLUV16dYAmXX
Hl3StmCL2boDG0scyZEjlWkWvg//QMljy9iotWRMjqjyceSqXkFC7UmqsvLTw8/f
iRo3C1cmwLPkeMIfJHno+//0bFdWaQGcEjl1BDzs+0ouxT7D5HjPpbXDsTxpxN5w
PgZqHQTkaS6ifl/82ZnXraML1eauHFSi38CDBfXS23ulwCfx5T4h4K2aOy3A3ehX
rpLAEBPaRRaIosBngqCbftLgB9TKUxocMp3k7GoVQLzL5rTX0yMAFBiSrLvGA8dv
w1pCafpBD7bO9gT/KH5vV/rLWIDHgtNVoazOR/Ul5b1aHrqyxkC00iW1rhXSi0/Q
4Q/SyiOW8kr3CIRuMIKqfZKAoahrOUZ1Iq+e/5P8eBF7KjEx88OPw5IHmL5kx/8Y
Kdc4s++uiCa5hfS9W5Qa4GXv/d1mgCidJeQKQ4CcQGLvZzDIAcHUmQm4S4wInfaX
v0NLAqxOjVtjegghEcmq6GRAHIkcjAVXneX+ane9q/l/WxxxA52K9+1XbrxXRtAl
963n4Q/WXBfFUbRrB6nuUBlATuPdi/oyh05PY/6dVWQLZ23nfkPVCXJE4uRobTal
yYZtTv3geXJXwtO9xaun
=Hwth
-----END PGP SIGNATURE-----

--NAuYj0K7Umiq33rm--
