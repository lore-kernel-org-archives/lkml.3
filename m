Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965782Ab3DQGiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 02:38:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38775 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965761Ab3DQGh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 02:37:59 -0400
Date: Wed, 17 Apr 2013 09:37:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Alexandre Courbot <gnurou@gmail.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the gen-gpio tree with the usb tree
Message-ID: <20130417063736.GA10582@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130417154715.cd3036b3cc791800938119c4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <20130417154715.cd3036b3cc791800938119c4@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 17, 2013 at 03:47:15PM +1000, Stephen Rothwell wrote:
> Hi Alexandre,
>=20
> Today's linux-next merge of the gen-gpio tree got a conflict in
> drivers/usb/otg/Kconfig between commit a0e631235a04 ("usb: phy: move all
> PHY drivers to drivers/usb/phy/") from the usb tree and commit
> 76ec9d18b897 ("Convert selectors of GENERIC_GPIO to GPIOLIB") from the
> gen-gpio tree.
>=20
> The former patch removed the file, so I did that and then applied the
> following patch and can carry the fix as necessary (no action is
> required).

Thanks Stephen, looks alright :-)

--=20
balbi

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbkMwAAoJEIaOsuA1yqREOvoP/3LZ5YczwPycJD/SzJHIjWrz
jDMEzwmwD2PvFfJEFtIPMzC1RM11nFmnBf04nwDXJPF81cUdkIraNz1wYrIVlEec
Iy8EwtAaYDlGhXjAukiyLQ3Qg+wNUN+NCrYjzGAdGc+M+0l54+Mv5AEM1vunXtka
lTYI2qkdJ5Ye1LdTeCxnJ+Lv9ZcHUnWJWCqaN3gWET0h7t7YekFMHmL1CrfLHG0J
5yPhoLkI4YSZCzkLo+Oy4VqoeabXMlIigMmdoCjBr70DAC6jpQ0OGkmWpWma1HFa
DlnMoJdeTxMfMbGhvpHu6IP3L7hzn9fuy5ydlyw6ugYRyfMGrFkzDrsWU+1TRYaq
B+fl+z4PKLDWXm0hXRQ8UauyX77JIpgiJnoxkQriVEY6kzNiQ7FFitoCCRHqgj6J
3+M0TNt1DN8mFw1oDI3mqI1vHsC5JNZjlgsKSC1IWSKoUmBElJ7FN3m2aZ/fddbS
mWKkEFMSgaUv8ir7u9bYIe24Zb3Z26HjsJD9w9UJFi+R0vzLX23pXitKOBm60gQR
WrAMzbQDDRwA+c3YR+QwJjdk6i32jcIplk1u0PMGG7LoxpGO2/nWVbQ/534B11eG
JGzBTHFcwLbPjbH58v/2dMeLIaHuidQhFvLIzzErQ2kBZb4yVoi4rULNx/MlVyfD
xS77E4kOkGczRED1U6aL
=0aM0
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
