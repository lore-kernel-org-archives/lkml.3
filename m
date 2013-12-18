Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3LRKGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:06:00 -0500
Received: from sauhun.de ([89.238.76.85]:43213 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3LRKF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:05:57 -0500
Date: Wed, 18 Dec 2013 11:05:53 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 02/05 v2] pinctrl: sh-pfc: r7s72100 base support
Message-ID: <20131218100553.GB3314@katana>
References: <20131217023745.24573.3660.sendpatchset@w520>
 <20131217023804.24573.82351.sendpatchset@w520>
 <20131217210403.GA1196@katana>
 <CANqRtoRn--Ze3ayoag71iYTKXEG1eNa8qyXEAJ7vCZhRo5yHPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <CANqRtoRn--Ze3ayoag71iYTKXEG1eNa8qyXEAJ7vCZhRo5yHPw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >> +#define _P_DATA(bank, pin, name, sfx)                                =
        \
> >> +     PINMUX_DATA(name##_DATA, name##_PMC_0, name##_PIPC_0,           \
> >> +                 name##_PIBC_1, name##_PBDC_1)
> >> +
> >> +#define _P_FN(n, fn, pfcae, pfce, pfc)                               =
        \
> >> +     PINMUX_DATA(n##_MARK_FN##fn, n##_PMC_1, n##_PIPC_1,             \
> >> +                 n##_PFCAE_##pfcae, n##_PFCE_##pfce, n##_PFC_##pfc)
> >
> > I need to apply this patch, otherwise my i2c pinmuxing fails?
>=20
> Thanks. It looks to me like the _P_FN() bits would be mainly needed.
> Can you try to omit the _P_DATA() portion and check if it is still
> behaving as expected?

Nope, doesn't work.


--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSsXOAAAoJEBQN5MwUoCm2+60QALMbiG04e1NsC6w1sYf9K/fw
1FJfLByW1jhV8F4PUCpcQ6EwtzYe9PVhvlzlThHAG9TGvFjQN5s8se7IxpUp5/xN
XXZo4KznvIohX6CzcZdjld3zAIFdkB4BNGhBzEmYakAlrEklIR4gi7EusNcSyqwU
MfgXDU0yu5UJfCslojebsYWUVP9phtm/xuZeck5IJuuVHx5fYdqzaQQpoDxGU8or
EtilQjEjxsFASjfgiPabPiROok5IUbLipMS+YThsvstJ4gdJvCiwTLMgHWternz3
SiCbsI7PrCR4jub3tkiUHoVhD86tdYaS7a+fSUBMDREbZAECGGwENkLn96HcoffJ
60YGRILJeLFn4o3m8qqCXNpWr5bzZC5dtGJSZxKbnR84xIHX4JsYKF0E+AMFBEp1
9IqhaQi32WFO/mHAx5nh0/yim3gmTvGTTH9ub977djawFhqvh6Y0Yf32dxsFtMDa
ksxs+H7Xr+/KH+xj+5zogMKSXSLduszCVOXgqhnDk0rfCJdTLfe7tfiw1NO3YyMM
NZD2eCRG1+PzLBWFeMrStn6mUBF0raGbkoyLLgdb35flsbb7/XE2G6B3mDDMX1Tf
E9nx0T3LJes6kVoM/TPXwJvvLv7oA8EttJWcrds+1RHI3dOvbztp22UcUN9fS+0g
ZjvYd4yjU6hPflZGMU6B
=XTQH
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
