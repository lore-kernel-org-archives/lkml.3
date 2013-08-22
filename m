Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3HVJu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:50:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54197 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3HVJuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:50:55 -0400
Date: Thu, 22 Aug 2013 10:50:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: eric.y.miao@gmail.com, linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130822095025.GR26118@sirena.org.uk>
References: <CAPgLHd9Eey5pbDjQmSquHvJY4zpDBDtp9brzWn-s5P6kaKmvpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HywJcj55HbA57jnN"
Content-Disposition: inline
In-Reply-To: <CAPgLHd9Eey5pbDjQmSquHvJY4zpDBDtp9brzWn-s5P6kaKmvpQ@mail.gmail.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] ASoC: mmp-pcm: remove duplicated include from
 mmp-pcm.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HywJcj55HbA57jnN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2013 at 10:37:20AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Remove duplicated include.

Sorry, I already applied a patch for this which I saw first (though
yours was actually sent sooner).  Thanks.

--HywJcj55HbA57jnN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSFd7eAAoJELSic+t+oim9/IUP/A4srfKOEgUtfhcfDKlV/nGj
+ztlHqVM0Dw9HalcqT30hhhwaI4D57xbntxY8Qxvj3HmvvtUXoEij7DA1/IjUsXm
nC5j/7ymDLv+p6tnvkBrP3QSmTR5ndfFj+DILDZ4b9MbEbfitzNWMyV51BctCaX9
3ldXg+XeoN+geO+aKlz3u9l7KrAlrBz663MOhLjug4pHjhhtfhv5kJyB5z1fWviW
Ooyywn90kZdOyoCNuzPdByhOS2LYqHdNKZLZDk+r75f+a+38eDZZJfJQ6X+arXmP
ak/ZnFSOl4XoX3G80QM490hvnyKemMoXSH62upCvDqOjyCvsT/QMBIrLRz6710pI
y4MaCjv/I1WKHQqpyWSlRTL2uAcFQ8vRtWUN+kOxjd13CiYCkwXZUXd0YOiKIJNe
OQ8aI6IdOj7Als19tqcz14YIcXcsGIddynN6Cy2Z7jR87D+9H+TFfsChSUGQf1hN
RHVmIJhcf8DRAuYl1/t2/2wJPFQYUtmEa5RTS4dwItLs1kqo0Zr6wJmDaCQ4O2F5
Eq7BbYLyTs/9MWvkHiKY29pRjSDyOHsuvqWWGYdxqDl2KijTZriK/+PjwF4vJgb9
aSML7NImdSRq0Q1PplyY4c2Gtw49jICWy3vtXL26YlVOKED9bSNHlhUKAHUk6fXt
lvNWmoEi4i5FoZ208r2u
=bcH2
-----END PGP SIGNATURE-----

--HywJcj55HbA57jnN--
