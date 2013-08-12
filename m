Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3HLITV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:19:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52476 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752474Ab3HLITT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:19:19 -0400
Date: Mon, 12 Aug 2013 10:19:16 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 07/10] pinctrl: sunxi: Add Allwinner A31 pins set
Message-ID: <20130812081916.GL2911@lukather>
References: <1375609657-15434-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375609657-15434-8-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B7kmwdlU7aE/dafw"
Content-Disposition: inline
In-Reply-To: <1375609657-15434-8-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B7kmwdlU7aE/dafw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sun, Aug 04, 2013 at 11:47:34AM +0200, Maxime Ripard wrote:
> The Allwinner A31 SoC uses the same IP than the one found in the
> A10/A13, with only different pins. Add the pins and the associated
> functions found in the A31.

I'd like this to be in 3.12 if it's okay for you. Do you have any
comments on it?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--B7kmwdlU7aE/dafw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCJqEAAoJEBx+YmzsjxAg0zoP/0MoQapaalpTPE1biqnRlnha
RrSDEUpiqZFYO5TxORqdMrbywMM4QynIUVRNdKqhKCBUdo4WZ+F8Xf6MC4tHS128
1Nilt5xn0D+jiQghPdpsAnqgbVZ03uootICX9h4vc6CK3DDWO8ciiBKLfuFfIv/m
f6EThWP5CeHb/NHW8zHZcFiSPwbnUa2i+QVPZsd3GkwwRycRqRO532HK8d7IUqZR
U5jwzeXwn7dJmo/y5X93hGXAAUFFVYr+0uMQmxwsGQ3rwgovhYTGFnhsT8QSAl6m
bHkqpkyUSGKbDuAjoIuwhMpr7KgddKdkV6hO2ZO5nZLG2skBc7E9NLTq3QFQaueO
dzxZ6r6QXwmtMM1FMDIdWHlEuAA7z9wxLVWtuI6JGicxjSv+7WAa0JV5Cvym6uCG
doYfw8bc0hxtqU/KdJBLadWV7z5lwERpJ1KAoGNeChtWu5C0BgB3TZ/4ru1EbU/r
0L1MvfmQzu58HfNys2NC0Ve0w5tl2MJBeQ5qlF6o9CELurysQMz/SmZ0MIBtTfkt
F4Pd4v/KjJOfZwMXyIBT4hs2hYeNM/oddifyNCumwzLKPs50O8djZYwouz+mEx5L
5cWnkLjPV6RUzIppeSYopx9ZnbJ357NB9FdkfusGxqEF83PdOD2zKY7tzYw4A4Za
9+/Xwi039ID/K+5mcoLL
=pdQv
-----END PGP SIGNATURE-----

--B7kmwdlU7aE/dafw--
