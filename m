Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182AbaETWPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 18:15:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34799 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaETWPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 18:15:47 -0400
Date: Tue, 20 May 2014 23:15:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org
Message-ID: <20140520221535.GG12304@sirena.org.uk>
References: <1399173921-3766-1-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5WcUv4ltjScdJlXE"
Content-Disposition: inline
In-Reply-To: <1399173921-3766-1-git-send-email-kaixu.xia@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 15/15] ASoC: pxa: remove mach header dependency
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5WcUv4ltjScdJlXE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 04, 2014 at 11:25:21AM +0800, Xia Kaixu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> As we are moving the mmp platform towards multiplatform support,
> we have to stop including platform header files.

Applied, thanks.

--5WcUv4ltjScdJlXE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTe9QEAAoJELSic+t+oim9FucP/RbIlxP6LI9oT7BPMjfQCYJE
wq6slY68VOHwUIFs0SKSeb2Cly7BuX0yXLPtZpWH4HWRP/ddc4+z/3y0oCzVnxNr
RvKk9PGCNptzYRB4c2IMH9fQ6YFYb+qT7FxGY5NUGK5029DLmfaIDM9E3sCC216F
xtb/0tXNGbunTwch6rJYA6B681LZBf/CR3b8U68nUROtDlgY+Yzt1XstJOs4A8CU
tiRoyPLmgbHScqkXz5PPYPVw0eeJgIs4ujf0fWRKsIU8jkhnAb34/7w3lotdF6/N
tfjiz8rB+/HZ51NgqtF+/+ZkTyeciOo8MnWSxWhaK+M++KwHZqHRvlV/dv2X9/6z
4v7/3o2z8LdWd0L4g6SBZZTzZqDOBc9qCGDrLVvmGLndbSWVriJd29LDAgSWG/Oz
HF1MNuB7XSp64ihnEnYE1BNrOq7uY9WjT+nT8XDl/dz9cSXxJ0Y9IkseLvzW2/am
pg6s4gc2SeRKf3Rx7tsiQN9+PNiZEAaq183G7x2vgfe9dNUpUL8mZy+guzJ0B/GY
aR2hgSfBh4yebF48cHhxyJdNLhG4g8oxK1QBzqk5Sa9HueOvE5cnouy8G3QNDp6N
3Y2ZSiA8tE0uw7vYxueURXuE9P3tvsrgcC6CW1kviO9hiox2Ze6GiJv5Nx7ycUW2
Zs+DbtgnuL7pRamE0xlU
=QdPf
-----END PGP SIGNATURE-----

--5WcUv4ltjScdJlXE--
