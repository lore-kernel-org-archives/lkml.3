Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbaGDKKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:10:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57356 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752764AbaGDKKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:10:05 -0400
Date: Fri, 4 Jul 2014 12:07:47 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH v4 0/6] clk: sunxi: fixes, cleanups and A23 basic clocks
Message-ID: <20140704100747.GD13487@lukather>
References: <1403798144-32188-1-git-send-email-wens@csie.org>
 <20140702223552.7440.60829@quantum>
 <CAGb2v67ceT8X-zmB7ULPg6Kqd8PRpmo0x_Vu9iF4s_6euXg_FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kvUQC+jR9YzypDnK"
Content-Disposition: inline
In-Reply-To: <CAGb2v67ceT8X-zmB7ULPg6Kqd8PRpmo0x_Vu9iF4s_6euXg_FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kvUQC+jR9YzypDnK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 03:37:36PM +0800, Chen-Yu Tsai wrote:
> On Thu, Jul 3, 2014 at 6:35 AM, Mike Turquette <mturquette@linaro.org> wr=
ote:
> > Quoting Chen-Yu Tsai (2014-06-26 08:55:38)
> >> Hi everyone,
> >>
> >> This is v4 of the sun8i clock series, which adds basic clock
> >> support for the A23 SoC. It is based on my initial sun8i bring
> >> up series [1]. This series was split up from the original A23
> >> series [2]. Yet to come are more clocks, reset controllers,
> >> prcm, pinctrl, and mmc.
> >
> > Hello Chen-Yu,
> >
> > This series looks good to me.
>=20
> Thanks. Assuming no one else raises any issues, I consider this
> series merged. I'll send the next sun8i series later today.
>=20
> The remaining series still have some clock patches, so thanks
> in advance.

I just merged it all in sunxi/dt-for-3.17 and sunxi/clocks-for-3.17.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--kvUQC+jR9YzypDnK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtnzzAAoJEBx+YmzsjxAg7AgQALxfGqF80RCk3v3dmgCOn4uR
gL1BoiGcY9m8DAHnVrScF9m6kvaAwaNiODMvmq0MJvBTTsPXrk7cnfMqP+BmEGr7
9bybzWMkHj2meSMwE8B6TnC1FjSBUT1xuXlE+uuwuGsJhbme/yajgQoifPwyvrTB
L2+GQMfICKij3K76ihLR6aqONwIJuNGNt+J/R62zgUmqMsUY/ZA0o1BHraVY5ZCN
tlCqm61YQEVWhI3hKWb9hvfdzBOHM5FHVOaVTkLgZKvuGfKnGd5jqZvlNAT/S6vP
EfOyjkDz16Xm+w06B/cLvJVthRwxOobiurtZToL+YE/rcvsAqW6Vko4OlYtQv1xq
wN0cfDWln3f5dYlK9C4vHEaq32EbNrdF9fTQKBoOXXg4CEFNwfPAy5lEGzjqhOOd
k2S+i20dO3Vv2dFQb7IH4DzUJ+U4wt3FBkPdvsTKOV6odeK/7d1PiZ6CtxRs+rMH
kSUihm/IXOEEjAUTf/XzAYGznQv9K1a1aeJ/eqTuYOBVrsYiY292Zir0CN3fL3Tl
wpnQXQvRWOYCKyw6ySsFQ35QRM5kXM1r5s9IpppK6Q/X7zXCEw6RuecJC4Qls1L9
K13+tpJoBccaD35GYPpBw5YL7Ct6oJJtq2M9CN2vgn7DR57A7lMDaUtSjKvy+PwC
TFQjyVs7C3lNYLO1Erf2
=5BNR
-----END PGP SIGNATURE-----

--kvUQC+jR9YzypDnK--
