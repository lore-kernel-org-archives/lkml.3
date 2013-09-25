Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3IYTuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:50:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39831 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752853Ab3IYTuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:50:14 -0400
Date: Wed, 25 Sep 2013 22:50:12 +0300
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Olof Johansson <olof@lixom.net>
Cc: Kevin Hilman <khilman@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, Emilio Lopez <emilio@elopez.com.ar>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] Allwinner SoCs High Speed Timer support
Message-ID: <20130925195012.GI2954@lukather>
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
 <87zjr04vnh.fsf@linaro.org>
 <CAOesGMhTZS1MdHW9cL4s_X8jUXHS3VkNZupCfX4ZGroL6k4gEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cf0hFtnykp6aONGL"
Content-Disposition: inline
In-Reply-To: <CAOesGMhTZS1MdHW9cL4s_X8jUXHS3VkNZupCfX4ZGroL6k4gEw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cf0hFtnykp6aONGL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2013 at 11:14:46AM -0700, Olof Johansson wrote:
> On Wed, Sep 25, 2013 at 11:13 AM, Kevin Hilman <khilman@linaro.org> wrote:
>=20
> >> However, the A20 and A31 come with 4 of these high speed timers, while=
 the A10s
> >> and A13 only have two, hence why we introduce two different compatible=
s.
> >
> > ...but the A10 has 2?
> >
> > -ECONFUSED
>=20
> A10s !=3D A10. Yes, confusing. :)

Yeah, I didn't get to chose the names :)

For all we know, so far, allwinner has released, by family:
  - sun3i (ARM926)
    * F20 (not supported)
  - sun4i (Cortex A8)
    * A10
  - sun5i (Cortex A8)
    * A10s
    * A13
  - sun6i (4 * Cortex A7)
    * A31
    * A31s (not supported)
  - sun7i (2 * Cortex A7)
    * A20
    * A23? (that was just announced)

So yes, even though they are quite close, A10 !=3D A10s :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--cf0hFtnykp6aONGL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQz50AAoJEBx+YmzsjxAg2tYP/1+sQXpWIPoFpedpk3c5eT9B
7jut8aaKQW0wOibFk1+LYkOG8QJzuqhGfVPkNoX1YM5YPvM08EejLzWLtC5pDdCz
+BoDD9TyEUn5TaFyn+90s7gs612GmLpoFPpOb05cP9VIkioVkm8piw1Z69vAI2eH
wHneWxCUpmj58tY4i737HYlJyG8fp/4pGanxU4RuT+qwzf0sNUipnsaqSyRO/sSc
kOTZZ4d9VjCZLEtUjZnk80X49yH4UXHfLeCdc4Sg0GqVMzcduRYVPBTi8QIh/8ty
wtu9Cb7D6DzLYP39YODqIAqt9OcSouprLmJe0DkKBUPrAbHCD++CS4KJb8ky8WN6
jEgccer4HPpplAIWYL5nZgTvCKs6h0VE4q8wqctLe6vqwTm4PpDG2Fk5blmTmyBC
DMpXWnseN2OTyO9L9dXDPgbzxZaWsJKAApg7q0ys/7LVcIaikFDL99z6QIR/AMMB
WHvIaNM1yPsJf9sgu25+3GC0sD88+fhjypM/0z3sM2URm/YskYqihCs1xTyPQSHg
tgZbpDYyzw1YZ98WmUXx5H+DQg3dU6sIgKFzrWWEtXlLpuEmGTz/A36nISpvEpL4
Tt8k5HmYVt8MBvrLOx3VmgWSj0vfT0pxJHKpLw5/+CxTbYeH+O7zy8DzeoJO9tB4
xKy/oHGLNWQoTq8yOQSA
=LrAS
-----END PGP SIGNATURE-----

--cf0hFtnykp6aONGL--
