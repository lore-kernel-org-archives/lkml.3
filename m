Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaD1TKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:10:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51733 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752957AbaD1TKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:10:06 -0400
Date: Mon, 28 Apr 2014 12:09:20 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 3/7] ARM: sun4i: dt: add pinmux configuration for the
 PWM
Message-ID: <20140428190920.GA3134@lukather>
References: <1398701834-3719-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1398701834-3719-4-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <1398701834-3719-4-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 06:17:10PM +0200, Alexandre Belloni wrote:
> Add the pinctrl descriptions for both PWM channels of the Allwinner A10.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Applied to sunxi/dt-for-3.16, thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTXqdgAAoJEBx+YmzsjxAgcKsP/15PON8u+Wyo04Rtn8yhWMIu
1Ndv10jAz6hH4CPudlleaGSJQIG3Ei5/GCo6LiDhNPg12Lu8wtSdUvpB+FCI4qZV
mhufE6ZLp1u60eNvLrsso+RQgZf/2XB8S3G+dbSpSqNRGarZ1dri1sQ+WWZMqp8M
MqJxhpfPqk8U5+6U/WGWBdA3tmpZlrH5EOR0nwNvXVeEKMwEQSjaDS3nxraEm592
RsP7Fzi+KsQiy2KU5tehhn1f9GnmGSSfeQX5yNbA1TKoBdpEXVPYuNG7avomjW2M
zKaLabhe0nCYTErZFVG86W9TlEG9T0ZulzaaCjbcvgJEDdViluxPhdeu1SI9Dbsa
QcMpUBdLC1vpdzZFtTC7gUpScSA42lCFwEMKmHFxwn9kHl7uKV2uPWbeer4hcaCu
5wYDHnYZ4mNIliLqh1T6mdt2UQvs0/IPHTioaKRmsxDgNEsZOmTLM/rmjogQq/li
JQ/IbpXtTut0OHAsq2KDGCiG0vuSfFnb58a2X0txTCXm+1QLkVqjPIVXkDxm3+79
crfdKiEtmqNBAfMm/ud+eZ0PNfkOIzv9q/4LZzY51FiAKWgpD3mE/FgDrw+gu3Nu
sW7gEo9D0TBw9EAN/ayps7n/ATlvipXdbf622nELtSPeRBK//NQwVaksi/vfLQm6
s7it6ddaajEMyR6hb3Ty
=GDIc
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
