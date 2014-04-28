Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaD1TQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:16:01 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51848 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754877AbaD1TPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:15:10 -0400
Date: Mon, 28 Apr 2014 12:11:26 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 5/7] ARM: sun7i: dt: add pinmux configuration for the
 PWM
Message-ID: <20140428191126.GC3134@lukather>
References: <1398701834-3719-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1398701834-3719-6-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
Content-Disposition: inline
In-Reply-To: <1398701834-3719-6-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 06:17:12PM +0200, Alexandre Belloni wrote:
> Add the pinctrl descriptions for both PWM channels of the Allwinner A20.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Applied, thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTXqfeAAoJEBx+YmzsjxAgsUQP/isk6H/fjzMi4DAMRj4QaEmq
b40OFC9rupZ9KnNP9Jx+PGEWx51GMZ8VE+/ssool7b7YiarCDoc6vuunr1DYRQzb
OC1tsBXXHYcGdvqPX/CzEbHKuxhkpH4DTAnEc8LgZPJV+OLH5fFcnZHimdqL2Apw
mqi0mDX4n3Y8sC04NWZCYH31yqEq97cfEVEVZCvehTMRyXr+EN7L75tc02LzG4r1
AbIpChyOg31rgbfjRjlWImO0PLwwvZG/5rGBpVDv2IZTEq850YTY8eKcu7AgmsPl
GFkHo6cY7iuZbYtBMceJGUTX1gwmweXI78dZx3VV9g4iVsMPSV5Tz0xqhIe4mrlk
n+YCI74Ho3pyyVM73MchSWbt9YR0o+riPvPUm08ukNBs82WxUuHPWcwbn9DUn2/T
FGGJR+oTwBOr+CudfwqO39vStGu7NehbmMKvztU43L5y+GX2AQ3/TRvTZxs/S0p+
+x1HtUQIXXd2mC1tfTDib4Qin+5sghaD+6p5YTKGJbK4NIIuGR/pNSeBDUAwZRwI
LOFwLV/N/yIumQ52XMKrxRRejtMq0Mwt01j65Z8Atg+iKosQkjBuMFZp2654w/1k
68Q2N+mvtUB05FYTPaJ1C20jct+6GHWRXwJqsXb1Ec/Qmkvz/dJyhor11fw8g1FE
+PSvmPUt22F/ytR8Fb+E
=k+AL
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
