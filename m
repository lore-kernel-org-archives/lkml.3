Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab3DWJCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 05:02:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab3DWJCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 05:02:13 -0400
Date: Tue, 23 Apr 2013 11:02:08 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Roland Stigge <stigge@antcom.de>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH RFT 1/2] pwm: lpc32xx: Properly set PWM_ENABLE
 bit in lpc32xx_pwm_[enable|disable]
Message-ID: <20130423090207.GA29222@avionic-0098.mockup.avionic-design.de>
References: <1366696891.28314.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <1366696891.28314.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Wb/9SVNTCvuMlF+gmVAIj6dEvfLtpY4MVuSy8YgSUxf
 GrZB0lcd0QZXQQtxfLaDLpB1zrORdQpuzzYAl/tH/u8ia9jtRo
 tPX7JE8OH1mRUBxBfcyL3np3YkUrF46jnQmXfrXa4BETve6SK1
 RvCh8GQCSvKo92A5RCaJ7JWwOQGVesKYJq2O8sY/+VL6UdgK03
 JDb6QzImjpeb4JeVkW8coEkzWHVArIoeGCd/KXjuC99B7FAqLx
 mDRy01S6dD2PWfnVPoyAzBnA7ssG769Eqy9dpkOCAzotJl7y0s
 d+ayI5Rddfxi2wvX5isjKYHNWmruuH88qIPpE52apC2LhLMfXm
 YHpE5I1OAlWDqA0WxfSiSPxNEK/2UGWa2F3QHPX0MZ0k+SeTsV
 kX4KWwWcVDbCCMxrYBKBXhDPYfgX94Q9co=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2013 at 02:01:31PM +0800, Axel Lin wrote:
> According to the LPC32x0 User Manual [1]:
>=20
> For both PWM1 and PWM2 Control Registers:
> BIT 31:
> This bit gates the PWM_CLK signal and enables the external output pin
> to the PWM_PIN_STATE logical level.
>=20
> 0 =3D PWM disabled. (Default)
> 1 =3D PWM enabled
>=20
> So in lpc32xx_pwm_enable(), we should set PWM_ENABLE bit.
> In lpc32xx_pwm_disable(), we should just clear PWM_ENABLE bit rather than
> write 0 to the register which will also clear PWMx_RELOADV and PWMx_DUTY =
bits.
>=20
> [1] http://www.nxp.com/documents/user_manual/UM10326.pdf
>=20
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi,
> I don't have this hardware handy so I'd appreciate if someone can test th=
is
> patch serial.
>=20
> This patch serial was sent on https://lkml.org/lkml/2013/3/30/104
> Seems no feedback so far.
> So I just try again, maybe someone can help testing it.
> Thanks,
> Axel

Both patches applied with Roland's Tested-by. Thanks.

Thierry

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRdk4PAAoJEN0jrNd/PrOhD8YP/3T4We5Tvk/i06WiskdDFBL1
ixdDuYKm611kGQJ98HBxAlg3CjefRNB3rnUwTRb1R65gxrWQ+qfh9iqz1c16b0yW
WdrcelwGjpZZBCIGWye+S9DHMJRFQK2GF5osuZhj4qOXlghtPIiAGYfijUNJa7eB
Gb1Xvg1HhG1GqX/iudtxiarrLhTWBi6nNQAvclJTi32Y+ekcl+2HZc4nC/RA2sHB
mTPJpmdLnYxAU6D83FKWmX7E7bociVyu/Afl3vRwdXXrkCYXvzTnMSF/IUVtkjrI
UX5Q6rC+dkOKvT4Hzq/UUY+FJGyFF661KHxiVOZYdZb4QvAuAa7PDl9PaA4rIlJY
t6xwVR9YkdH0Gan5cJxBmJsSoYqkqTot9FNhvINeGTuLZQyK3Rij9KWAXlY21QMu
hbo2M3hU6OLuUfkbFl/EJ2BUwdROszROYZ7iDfPNWQEIMR1fKlDj6T5JpCxGlBUb
vhtdY5Owxb/kgJyNpFfP85GrvB85siBRPia+Lny4UK7wZ3FzT4rEvFBfOF147ko7
RIqror/IryZf+2OB9a136/KeRr1zl5NfxXee/hxNNjmW2MQH7awcMnasAteDyoLR
CR71JR0TYaH+egLbla/FyvBWKgqx6ezZeLqED+USEDaKQEO4kVwEYWY24gRFvCp6
PBNA6KSJGIHiYTNSXVRL
=yyC0
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
