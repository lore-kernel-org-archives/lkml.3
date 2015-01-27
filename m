Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbbA0NNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:13:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36215 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbbA0NNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:13:37 -0500
Date: Tue, 27 Jan 2015 13:13:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Bintian Wang <bintian.wang@huawei.com>
Cc: linux-kernel@vger.kernel.org, srinivas.kandagatla@st.com,
        huxinwei@huawei.com
Message-ID: <20150127131327.GV21293@sirena.org.uk>
References: <1422363029-19476-1-git-send-email-bintian.wang@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Pzq24Sl94SYEqopo"
Content-Disposition: inline
In-Reply-To: <1422363029-19476-1-git-send-email-bintian.wang@huawei.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap.h: correct the description of structure element
 in reg_field
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pzq24Sl94SYEqopo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 27, 2015 at 08:50:29PM +0800, Bintian Wang wrote:
> Fix incorrect description of structure element "msb", which is
> described as "reg".

Applied, thanks.  Please use subject lines matching the style for the
subsystem.

--Pzq24Sl94SYEqopo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUx472AAoJECTWi3JdVIfQ8CAH/Ax5aIIemriaRoyPuXp4Pc+2
QDPErdn2/p3Z975Q0Ynux0RCkt/2KPfqrRzSDwu+ckJAe1QJQBkLPGMrzmaB7g+e
ZpWqxUoZisa9a5qhQWMkH3y1VOUwb30oPabM05Ih17P7Xxx/MWcMt4UMAEVdluLn
u+Ce3PfxuHXZU72LOjSOJe5+/ySyL/AF07KsF4Qz/cARHaR8ZxuqIU5MjXG5Ljf4
Oo0CDm6nOEwCMgVCOERWUgamqO2cWavSgtZYwh2ZQ9ql8w10dAySGhzxeLdhKEZI
htL8i7/aoBFEreI/sKLaAxF0hmeOUuQ3XZDv2OZsPYFvdi/o2WG8OcVcuBMZRZI=
=0yO2
-----END PGP SIGNATURE-----

--Pzq24Sl94SYEqopo--
