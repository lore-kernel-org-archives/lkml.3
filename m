Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaBROKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:10:06 -0500
Received: from top.free-electrons.com ([176.31.233.9]:45217 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755128AbaBROKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:10:04 -0500
Date: Tue, 18 Feb 2014 15:05:16 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: David =?iso-8859-1?Q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
Cc: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 1/8] clk: sunxi: factors: automatic reparenting support
Message-ID: <20140218140516.GG3142@lukather>
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
 <20140217100215.15040.63745.stgit@pagira.o2s.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AGZzQgpsuUlWC1xT"
Content-Disposition: inline
In-Reply-To: <20140217100215.15040.63745.stgit@pagira.o2s.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AGZzQgpsuUlWC1xT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2014 at 11:02:15AM +0100, David Lanzend=F6rfer wrote:
> From: Emilio L=F3pez <emilio@elopez.com.ar>
>=20
> This commit implements .determine_rate, so that our factor clocks can be
> reparented when needed.
>=20
> Signed-off-by: Emilio L=F3pez <emilio@elopez.com.ar>

Your signed-off-by is missing here.

Once you added it, you can add my Acked-by

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--AGZzQgpsuUlWC1xT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTA2icAAoJEBx+YmzsjxAg5XcP/RzuL8bgLRMimiNCl1CyFMld
lvpOZG6xCaov8c9kC+BafPfxdlyT1lmZTUS0bfqE2lMhQ7s5GhC81wT+9ZCGN9Gn
iubRJkBUO5YDui3IEQSbeTBgiA9r73n+DYP47AzwidVaJmIKDbBev4JKnIYFx+yD
yEyqluPHP7j0vj8LQOis9LmsEiDWvpBggcYTRHoI5JdFYleNGv+7mfeSZgQfZm7c
ACv1hGS2QC3e+Rz32PzUGbLJyTVrSehIsK3Z158WVVY8iTkeXvDm/zlUuolSCg6P
SwCFxF0TSqgNXPFHy2YjVm/P1S6b4Dc3ZOZOJ0paQNEMbVcBKWNq/4Gr/L1OHBQC
Cbal0P3NUyEH+NAryTnJUMzCAvQqCGy39NlSeOyb8Rk4AIHXV6kJ7OV9fnredsUK
E9AaovmlyuDwEr9o+wQz8LkMtF+QJsO9016LtbEUHHTu9sgZhudP3f/COmi8YNob
Nvo+9mL83OmP3UjpGoEJh5mzBn90qz9umlwBZ/JCDjwRHiTsxlpvUlpNkbVR/LtO
8ggkDwy9j0+E6LT0DvTSD4bKAuSd5uqBld/Dc7sQ9L6jTz4IjiPX0glHj2mDloA4
cbi2AY04KPqoUov1bobfjTlOAe6VI7ECZzUBMQmuucxTtj6YCs18+JaYObcjBekZ
SzG9uXbSlbT4q1mzGyFU
=rAhV
-----END PGP SIGNATURE-----

--AGZzQgpsuUlWC1xT--
