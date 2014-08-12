Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbaHLV2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:28:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60454 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaHLV2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:28:16 -0400
Date: Tue, 12 Aug 2014 22:27:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140812212757.GY17528@sirena.org.uk>
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
 <1407861868-20097-7-git-send-email-javier.martinez@collabora.co.uk>
 <20140812172552.GU17528@sirena.org.uk>
 <53EA61B9.2070805@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UU1ixziQytOgr6B7"
Content-Disposition: inline
In-Reply-To: <53EA61B9.2070805@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 6/6] ARM: dts: Add tps65090 FETs constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UU1ixziQytOgr6B7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2014 at 08:49:29PM +0200, Javier Martinez Canillas wrote:

> So, is adding these voltages ranges (the design limits) in the Peach Pit =
DTS
> file directly an acceptable solution? Basically what my previous patch [0=
] did.

> That matches what is in the board schematic so I assume that it's safe to=
 use
> these voltage ranges for that machine. If so I'll drop this series and re=
post
> that patch fixing the typo error and commit message pointed by Doug that =
were
> already addressed in $subject.

Well, I think the question is if you understand where those numbers come
=66rom and if they make sense.  I've not seen the schematic for the board
so I can't comment but it is quite unusual to see ranges listed for so
many supplies, for things like SD it's obviously normal but things like
video_mid are a bit more surprising.  Does anything actually vary those
voltages?

The change where you fix up the supply mappings still makes sense of
course.

--UU1ixziQytOgr6B7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6obaAAoJELSic+t+oim909kP/1okMQECkjemzwIec4io27fl
qYZJEBgB9Jsm6J1k2iko77mU6fkQVoLJPbXKXhY1n7TecUbb7uPIcoYfAeVSTdKR
AI0jwaOZTyWbPf87/UIiW6WUIgzRmp5Ckit6FsQFm0bQkfIRJgF6NCYsx8KAOEEX
w90F0tncP0DkS6Z3lYaXwp9WL5G7STWJRopHjhYxTSXOeD/Uhu41PsIJ/aDHlnMi
2JiyoBzVX3fGRxfa6uLAxPNUBXTVGtQUreet+HcQRZmnXRkXTgb0wluQ3o6gG0qj
bh5JipFtjQ0v/d6ivPqaS9UraEF+Po8qW37Lswpv102xwmEViQpQIPqCcRRl1x6i
0EDJdXczVBKH6YJWHuoswPuMrLIJ1I0OqPWaIQTVfx1v9DXgTpHBZYyzPLGf9KRs
fmq6S1mNgYHnhMlapp2VbSWsH9PHlVKPbVrcSmVWQx67QaFg1C23z50lTUh82zxK
nPM5ET3fYkxs0RbYbrNw5eAKO6SdYswBggD9ciMDL1pyo12+qEoNX3/SFzPlSnjz
ppO82J4GImONl3FuuiXw9GY0I9IGjGcIeL7bUZ9JQNno+wyG29lpuii4xLft3yMD
i63dM6Q76/VR3JYDotQabSaj4U/U4s2Y+8OJjLjvRIc0jAQE7jA4E7ef3tfgGWp6
gtaPrvtN6bi4xxWUvq6j
=XQWs
-----END PGP SIGNATURE-----

--UU1ixziQytOgr6B7--
