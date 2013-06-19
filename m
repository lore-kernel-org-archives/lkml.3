Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609Ab3FSKNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:13:25 -0400
Received: from sauhun.de ([89.238.76.85]:52442 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934265Ab3FSKNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:13:23 -0400
Date: Wed, 19 Jun 2013 12:15:27 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [RFC] i2c: add deprecation warning for class based instantiation
Message-ID: <20130619101526.GF2950@katana>
References: <20130607090623.GC3428@katana>
 <1370596166-12404-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="juZjCTNxrMaZdGZC"
Content-Disposition: inline
In-Reply-To: <1370596166-12404-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--juZjCTNxrMaZdGZC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 07, 2013 at 11:09:26AM +0200, Wolfram Sang wrote:
> Class based instantiation can cause huge delays when booting. This
> mechanism was used when it was not possible to describe slaves on I2C
> busses. We now have other mechanisms, so most embedded I2C will not need
> classes and it was explicitly not recommended to use them. Add a
> deprecation warning for drivers who want to disable class based in the
> near future to gain boot-up time, so users relying on this technique can
> switch to something better. They really should.
>=20
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

No reactions on this, pity. Deferring.


--juZjCTNxrMaZdGZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwYS+AAoJEBQN5MwUoCm2NIIP/2LbtKw7sFmJ99GyBNDXTjg9
xnN0LJIZkCjxgTXBYoR2/JbHbcxXDbv1NDm4WpL7Ic0bUN7VSaKZjVnLEII/bsla
M0ZgGn74vgtSOFyuEvhYw/OUhTmvx/ICGDY0YC7y5A1jEaZNdYIxF6cNiGmQgZBg
Vhd+m+lDJPhwB9wcBIly8qLBxNzBE57UZqOPsSLRRbPiJIfqHjKGztBYb69B57tS
tVcHsdyL6bal2/nfCWcxUPQBgvYyQhUWPeyffKq2eQHEkjfDu51AIEpyjdpLDnTW
5kx8Vf46am9CyyqVecvhKqgUF2nE38qMcafJ7bK7oKebUwhWS37qTyAdsfGMe+kG
YkNyDjSCPoiF1z7wBHgWu/0KaddNCyN65wS1xyso385jt5EInsFS8G9XQSBiKSJs
jDYDF8UGlHIrcsaPD+S5bR31DBJJuyUrOs3Fzk6SGvSaQ3yqXBHmE/F2MfjTbgmH
1nkJuU91XdS3raOOEQEQRfAY1Gzy6kbCFs5MLXtY6gatKwJRv5cvC9psIpU/MKim
GAOi5Jp8JHBgfIxYDO6clHb2hjhWXWNrWb6NS9vdyynLjQLkF/23PnPiHtfriMZ4
773s6xDWfWJziGCqzxGQ13yKlyE5EJq/GsXkKn6929/P9OSg//dzV0Gcm85/mY76
drK/OVXDyNHKk3Gk+RV0
=R/JS
-----END PGP SIGNATURE-----

--juZjCTNxrMaZdGZC--
