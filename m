Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab3JTKZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 06:25:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33848 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751024Ab3JTKZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 06:25:10 -0400
Date: Sun, 20 Oct 2013 12:23:14 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: "Victor N. Ramos Mello" <victornrm@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drivers: clk: sunxi: Fix memory leakage in clk-sunxi.c
Message-ID: <20131020102314.GO3041@lukather>
References: <1382138871-9366-1-git-send-email-victornrm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lqu5hkAdORZH7CMT"
Content-Disposition: inline
In-Reply-To: <1382138871-9366-1-git-send-email-victornrm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lqu5hkAdORZH7CMT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Victor,

On Fri, Oct 18, 2013 at 08:27:51PM -0300, Victor N. Ramos Mello wrote:
> From: "Victor N. Ramos Mello" <victornrm@gmail.com>
>=20
> Fix a possible memory leak in sun4i_osc_clk_setup().
> Moved clock-frequency check to save superfluous allocation.
>=20
> Signed-off-by: Victor N. Ramos Mello <victornrm@gmail.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Lqu5hkAdORZH7CMT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSY68RAAoJEBx+YmzsjxAg0Y4P/jJEddHPkuV5Xr532+oUK932
eQFMHd+e91rGa3Rz9GoEEsJMyHG1j3iGXcqkQWy+j3NJsMN5cc8Fy9Lv7vNDLkX3
iPxOUDHjj++TyCHOZyPyJQqrQcxcNAozuJlScPmS4ejm+aWp/u4mTmGl2vSLHyHJ
IpUTVb9So9QPzG6J/KMOUki+dspCil+qsNeDCOXtonLC2MSGQhC1CxfEgfXU9e+V
NBwQUK3byUABkudaWh0Egs+9VYvk93c+sUzWAoKl2RfwRocjHCg+g1OISt9Rwg/I
rLzJdDRkTBquQBxTI3ucEeX7m8FNhH+tnp6TSnPbXymMJawNzz5nImW4Zh8IsPJJ
nlLpj/RuGx5OuSrPq7KH6zWAm6aWYVqVsCda1QlBS7KQoR9aMNOHOeyvD30uCJHP
fQwpxEVoawT//ezWNponQBC9eqqaT+K4+P+9uHCKaNb87U84uy6UO3XuxkE8vhL6
vo1WAXKsFmkvqF/DuNcIX4awJ260HhW8c7myK6ciqYEjxH9WfH025V9+NarHnvpF
hB21zZrYhL1NiYY3VjzWhFfucc9y6m0+PAirctACDoGorK1PZG9vXifs7DUBFA4d
qtjmrOBj+vcgR7nTen/wX6vkjwBRt7VtHHW4qsU81dIhe0qkfMOKgI5MQkUwlzV4
l7mfnj+Xd5aCYJzI/Q1t
=bvkc
-----END PGP SIGNATURE-----

--Lqu5hkAdORZH7CMT--
