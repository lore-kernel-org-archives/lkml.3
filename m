Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaHOI7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 04:59:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36452 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaHOI7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 04:59:40 -0400
Date: Fri, 15 Aug 2014 09:59:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Tim Kryger <tim.kryger@gmail.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Haijun Zhang <Haijun.Zhang@freescale.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140815085919.GG17528@sirena.org.uk>
References: <1408019940-11153-1-git-send-email-javier.martinez@collabora.co.uk>
 <CAD7vxxKvzxvmzgx=S5ZZn54ts99ca2TqBYFvY1SXZQZDkhjq3w@mail.gmail.com>
 <20140814151958.GY17528@sirena.org.uk>
 <CAD7vxxLHtk2ywHGoBtDp6x3-5BtDdaFnCdc_pfgMwq63Cg8Qow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qvf+BwRAf9ngBazt"
Content-Disposition: inline
In-Reply-To: <CAD7vxxLHtk2ywHGoBtDp6x3-5BtDdaFnCdc_pfgMwq63Cg8Qow@mail.gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] mmc: core: Use regulator_get_voltage() if OCR mask
 is empty.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qvf+BwRAf9ngBazt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 10:36:18PM -0700, Tim Kryger wrote:
> On Thu, Aug 14, 2014 at 8:19 AM, Mark Brown <broonie@kernel.org> wrote:
>=20
> > Right, there's two things going on here.  One is that as you describe we
> > shouldn't be putting constraints in .dtsi files if we don't know they're
> > OK for a given board.  The other thing is that on this particular board
> > it turns out that there's no support for varying the voltages at all so
> > it doesn't make sense to have to specify a range, there's only one value
> > anyway so the software really should be able to figure out that fixed
> > value all by itself.

> If constraints are truly irrelevant when the voltage supplied to
> consumers is fixed, why doesn't regulator_list_voltage honor this
> exemption and skip the voltage filtering that uses (potentially
> unspecified) constraints when output is entirely determined by a
> parent (or grandparent) supply that can't change its voltage?

> It seems odd to make callers be the ones to handle this subtlety.

regulator_list_voltage() tells the consumer what voltages could be set,
regulator_get_voltage() tells the consumer what the voltage currently
is.  These aren't quite the same thing.

--Qvf+BwRAf9ngBazt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT7cvkAAoJELSic+t+oim9n58P/j7dIEFD0zbLZjzRPAeWZWwt
POlcwTziEARpsbTPQKDyEXqOBFLQ2R8JGTmXTyesHPkDkllkP+OCB+bYIq7FiNVP
WBIxXNaEy1md172yoBriD1wcAy8lp/2Qv/I9l4YUr6Zdn5mfoC6TRWFCoTv8fZpp
xlggbtJFWQyfeZuEp/Oq2QyCkZdGl9MwIDBc2MlAYng2VWStrdPB5iuX4akBgmSE
TQS6GmFg1aKaxecgdOgpY8wHBfCbfa8aT99gEhtdUB6cSJHJTGjxkjvUw7L8+ifW
aY1EqTrVE73K52DYrrRsPU6d8/mwaIPhOkRDBJ1FGMMNxinbxmm2TDz0Lz5IL2S/
bCAROoOBJAFQ7vKNoc5RAEe+37fbEI9B591gPKkOpJMVUJhkh2w70G++h2eaCo5y
eir2l2vZBpwnxgcNPCgvR1X08n1CdwPzl5pxqPoxzs3XLrEz6FGKULzhgCASa7BL
VMEoteXds8f+xG5i2WIHbuTgNfxarAvaVQ326TrVxv46NpO3ddJWESG7rZQai7v6
/A+xIlGuw/NX/6uqgDnaLFZuZT6X1uH7GRD9/O2HEbPZVM+KxpGA12TWG9oo6NSG
8OLWX3R+7yqnBh9qT8fpA1Ar8hWEW++gqY0fLQ2d/9vENAWlNHVu4UyU5GwwTikg
E3uZGT0wt5ARkxgS6549
=HxP4
-----END PGP SIGNATURE-----

--Qvf+BwRAf9ngBazt--
