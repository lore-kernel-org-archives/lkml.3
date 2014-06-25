Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaFYUPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:15:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38955 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753257AbaFYUPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:09 -0400
Date: Wed, 25 Jun 2014 22:14:16 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 0/6] clk: sunxi: fixes, cleanups and A23 basic clocks
Message-ID: <20140625201416.GH19569@lukather>
References: <1403603980-31101-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D6IIOQQv2Iwyp54J"
Content-Disposition: inline
In-Reply-To: <1403603980-31101-1-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D6IIOQQv2Iwyp54J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2014 at 05:59:34PM +0800, Chen-Yu Tsai wrote:
> Hi everyone,
>=20
> This is a followup series to my A23 bare-minimum bringup series [1],
> which adds basic clock support for the A23 SoC. It is one of many
> split up from the original A23 series [2]. Yet to come are more
> clocks, reset controllers, pinctrl, prcm, and mmc.
>=20
> The first patch fixes the reworked clock protection code merged in
> 3.16-rc1, which unintentionally made clock gates unprotectable.
>=20
> The second patch moves the remaining "ahb_sdram" clock to the
> protected clock list, now that it works.
>=20
> The third patch adds support for factor clocks that have an N factor
> not starting from 0. This is found on some PLLs in A31/A23.
>=20
> The fourth patch adds table-based dividers for div clocks, as some
> clocks, such as apb0 divider on sun4/5/7i, apb1 on sun6/8i and axi
> on sun8i.
>=20
> The fifth patch adds support for the basic clocks in the A23, just
> PLL1 for cpus, and the system bus clocks and gates.
>=20
> The last patch adds the DT nodes for the newly added clocks.
>=20
> Patch 1 should be merged for 3.16, while the rest should go in 3.17.

Why should it go in for 3.16? Is there any user for it yet?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--D6IIOQQv2Iwyp54J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqy2YAAoJEBx+YmzsjxAgkQQP/3MJ6Qp0smyBlxhbveaWAhhh
7oRrCIYBu9d3xqRG9AnJPZQEVY+pUAtLBcJeHp23AYNAyntiAozHehOWOtzqgaYd
owDZM7XsC7Qcduk7FAlXxZlq+Xl2Z3xLe2yIK0CVjwbDlyOss9L/6Bj5csCU0HD8
7ebJz8Um9v1MqNN0zhK8kLgmnhBLxlSCB7LfU87cT0CXz/dgQniN89n+WON80F9+
yUDD08SwtBN2ETFCu2yxbEJTAwZLfEVX6oJ5vwbNSs+AJu8FDnTlqyRO/ijIdURH
nCOTR34Q2rvyVsBnrol6QJcI/OAqV8YKOjnqcrCof1iWlFr+Rc8Nm782KrK0W0j+
xtixDjVj9P76hTKCOQr20NwNvmc5mEEIfaZV1qfiB3Z7HlxQej85X4y2EZBUnENA
rBvc7M/S0VQfk8n3Y3RGhJQ/TNsB5X+UfEf3AORhQMpZABCZujhREtlPS8dWVWDk
piMPp7kLiq9AIKRRCmHq9apC4Gg8oKYfVDs4fASJ0F6jmmfYBFXRI+tAGPhn5Mh0
tidHVtzApQNxELYfUL5mn5f6LdGF1lBkzM3GQiswuOfOoyvSCKKVcHUgjnlBlINo
hGKqV37Pq5MBxKLpz8WQ/KiPy6iihhVs/A/pTMjWVamyyTHV5vLJevhtlxEHGrjH
aae+znbcpMRKw3XGfARA
=av6h
-----END PGP SIGNATURE-----

--D6IIOQQv2Iwyp54J--
