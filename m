Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbaHGNU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:20:59 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39736 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268AbaHGNU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:20:57 -0400
Date: Thu, 7 Aug 2014 15:20:52 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, ajitpal.singh@st.com
Subject: Re: [PATCH v2 00/11] pwm: Introduce ST's PWM driver
Message-ID: <20140807132050.GC1540@ulmo.nvidia.com>
References: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
 <20140721123950.GY30888@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <20140721123950.GY30888@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2014 at 01:39:50PM +0100, Lee Jones wrote:
> Hi Thierry,
>=20
> Did you find some time to look at this set?

Sorry for the long delay. I've applied patches 6-11 to the PWM tree,
though I've modified patch 6 a little for consistency. The module is
now named after the Kconfig option (pwm-sti rather than pwm-st). The
dependencies also seem to be redundant (ARCH_STI already depends on
OF), though I didn't change that just in case it's required for some
other reason.

Anyway, scream if there's anything in the PWM for-next branch that
needs to be fixed up.

Thierry

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT430yAAoJEN0jrNd/PrOhjM4P/R1u9hzekLIfuj4Gu+1FfD5j
kGPXYIUpxmyb+1Vxm/pFpMu3meWw5WZVVmS03A0pbgs5Y/B073ez8/xa4+p1b4mA
rL+ErG+j81coaEuBOvg5IXyMCJhQcmJLlL9nNY8u7Hdh3DSidbWTflGFohE6k+nU
QOConR8yochj/Mi0bTGVR4HDbQnGm1eYN4G16FYybfGXsim4wgBR6GDCTlHX2AS+
C8IUx4Pamcsa7hhMJVjD80A7E6lPLPP7FXO1Na3zZhEAtwzYWr/rZd1VS53SxS2F
eKEP0AAnmvQXdKmN1X/WJhNY+amNaEETMBFS3m21X+SMXWanmrjGB6j/1AkUf1kN
TOP1vfJuOEA9e8RuqeW+HrF59ToMqYVd1foNW7X+p3l3ziGP6ZHxxRnJjscPfBOt
s18WgOB7vIOEAmVOa0ufgNQDE3zJvU06nnGiw8BV2RadZ9mksaqsy2TDmDKke/Ei
Vwju/RHWkKOgo2HgXukc6Nhzmz6Ei+xCXYLQzLpZf4q4KdGs87sGJ+GpWnO+qTJ+
C6XcHKv6+2W0as7Voozzv7tSjVQbCgMaU2cPgXUfrWyR1Bp31GBPTxyJqd95CZcw
belEvIVDEwHXEgoNimQ4PerWMXcQFKruHWxSvbu3vvxkgqIuLet42LE8ufE/YF1z
QR0A+XyrgRfJsSYOQYfc
=LvDo
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
