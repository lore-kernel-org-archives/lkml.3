Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab3K1LXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:23:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59042 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3K1LXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:23:02 -0500
Date: Thu, 28 Nov 2013 11:22:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Message-ID: <20131128112235.GA27568@sirena.org.uk>
References: <1385662391-27573-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <1385662391-27573-1-git-send-email-chiau.ee.chew@intel.com>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/pxa2xx: Restore private register bits.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 29, 2013 at 02:13:11AM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
>=20
> The Intel LPSS SPI private register bits have to be restored
> when system resume from S3 suspend.

Applied, thanks.

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlyd4AAoJELSic+t+oim9slMQAIw7FQ288zfP6Md+WEf8tUl8
JpLjW5rpwQ1OgHgTPAuVCDNCjRjpTHo6e1FpQLMevpJqf4ASK8dxm8TmTA4WnVq9
0sQNrIMcnJmkIrdfvyhGiil55YOeA6BcH3t55Y/tCyRvtjgPHpyRpDM2nCAmsyLV
8GpxaODp5XzimNE5NuuCqClvwpdKDPTFaQL4RTkx1wvMfKc2EL87IYYIE2CEyjR4
7Ubp/uDBDlwQ3mZj0ouNPGcB5EL+SmrWVf3ygvDGTm6UrGzND4moGn4iyNTXLfih
u532UM0Qt/KMhIq7w0AGPWkd3kexKtX7JwStsWTkv524rvr32D6nemrsKK3uDZ/W
dv7dmUSRAsE5/KRuMM+hwiR6zJI19cKxd43liurY+HMHmcASL+OfAN+Vw4veJYKF
kLbKGDpPJ9dYkTEBX1r0IQfMvtPOJXV3bFs4Pm34HIsbVcLC6Y2Dg8iVdGLX130O
oK3oYkTcsaHcnbc9VXDlH3qsQAPcFgZKRLMeZjJkhiJ9dQsMhGX7cwhHfU/8ZWFR
P2mEBp1GRjMWDn5eMlBO1fd9Qvbq/rSYbH3uif2CQHUft+3KyKKV7CjOkNPq2Bqp
3W+BXC+TcYt60oMZudIToKjcPZxD5xT9UE0R/RpMDeInYR9Laa8vxkm97vU1ltV4
idBdWV4NcAnwzx5e652m
=101M
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
