Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3I0JtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 05:49:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38267 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3I0JtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 05:49:16 -0400
Date: Fri, 27 Sep 2013 10:48:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        sachin.kamat@linaro.org, wfp5p@virginia.edu,
        yongjun_wei@trendmicro.com.cn, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130927094838.GX19304@sirena.org.uk>
References: <CAPgLHd8rbL2mmN+hFb-Jqvy+tu7wyTj702Z0fKNG_KOCW1kd1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0btr6/5+bhBdui6J"
Content-Disposition: inline
In-Reply-To: <CAPgLHd8rbL2mmN+hFb-Jqvy+tu7wyTj702Z0fKNG_KOCW1kd1Q@mail.gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: wm8993: drop regulator_bulk_free of devm_
 allocated data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0btr6/5+bhBdui6J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2013 at 04:15:54PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> It's not necessary to free regulator consumers allocated with
> devm_regulator_bulk_get.

Applied, thanks.

--0btr6/5+bhBdui6J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSRVRzAAoJELSic+t+oim9fc0P/joFYFyoak9xJ+dblctMZRTo
gABE4l2BrFFRQNJRlyAnXdpdrsocjM1uFXvT0yMNb2iHYSJILBIxZA5pw9wHNl8m
vP+1yJuoR2hs1HoREPq89+b7VnEaI5jF2++9M85RxR0H1b5HlYErc646codrEuJJ
+2Ce9RZOIGXrpHiQK5EB+yq+LqQ5d6YtAw57UyZDfVXTFWWm2msr5ChlmYqhCsvx
NaGjFeu5h+mJ4EcCHIgJj6ffS8ZjExFuKxxsdycTUp0MINa1MKtEKNdTcsBRFZeV
WFZmZct//zT8fILfwWahvvBi0Lk7pOmXVw67W8w6aaWSnhRD6EueL3sIJvJQvMxE
DNJGjs0BGTs+FX0CXSrWQf5WlKiQsfSb4KkPsXCaQ675P4rNWnIBVOZw3CEfWXJB
sRFw6viFiM/9OdLBYKbGrF73dHGrEuSxfVtqWBTPNjuL/bncOjGEqzkVobrCW73m
Gy2JnM0bKipWdOuADcfBIK28zIJYB5+T1Uu/WSz4wdukBe8Ag8eTo4uYjclgcxRM
0iuLUp5sbe3X2nIv1aD1E9wjRsLlcMe7jvfuifzjWDYeNMqYrehcmZmo1IH/k6cR
rZmEZNc2ZRuySK3rmiZurcAlx2V/ilh3v8qn2ZLKuL2fx0WURRCIGLId10Zxczfo
vlZeZyYz42fybHx6Q7MT
=qBF0
-----END PGP SIGNATURE-----

--0btr6/5+bhBdui6J--
