Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab3ENMx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:53:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38288 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab3ENMx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:53:56 -0400
Date: Tue, 14 May 2013 16:53:51 +0400
From: Mark Brown <broonie@kernel.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20130514125351.GC20930@sirena.org.uk>
References: <1368514463-4035-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
Content-Disposition: inline
In-Reply-To: <1368514463-4035-1-git-send-email-srinivas.kandagatla@st.com>
X-Cookie: You are as I am with You.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1] regmap: debugfs: Fix return from
 regmap_debugfs_get_dump_start
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 14, 2013 at 07:54:23AM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>=20
> regmap_debugfs_get_dump_start should return the offset of the register
> it should start reading from, However in the current code at one point
> the code does not return correct register offset.

Applied, thanks.

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRkjPcAAoJELSic+t+oim9peEP/A5FnGQIykHJvzfq4hFyfnta
uoBHjSQ6xAvmAt17LbRTY9so+Nq+3ZDyiSBoBmvT8AUY4BX7rrql9kQIs2Oc3JCW
/2fWdJX1oZtYRnmfwk9q/KgIE1HJjuOiX3X466h+daKt/XM2RfbXzaxdGFwZ8tEw
fsuTqe0WGq9z2NEpdBb/secrPedpeaoYX8BuzW7u/8ZKSwPtmCHDRNnOY2O4ZOgI
DsABowqSr8p5cGoIhlVHg2GdoJvdR6QX20k281gyoEwYlPT8gOgTBEfyDOJ1xAu9
SVak0USFXuPsId7Rle8ovKZjD6+/kVOMhmse2bh7b4GJUlHuqlID6kp8AcnL8PWI
MomIKy3yAc8h2/kgSgtwu73HojdCDDk7cY8bkO5OnLrMff6W1Rxff99JYdA24vH/
o5DV7Lf4At1zG3eX9A1IdPROSrJl3puqzj9fTkF6mvwICVpemUJLQ1ojW7WMNhJi
URkvtvNQ2fIsOhL1nps0uGL4QTgZ4nrW/BwLbk13tmo6ijfXDoUe2mXePriGYu12
ewekf8d8nwK0Ot+3p8YiHPR3FU791x6yyDUDSwPODSakT77BrIzMzid85X3xnQth
omrgzmimPBXCG4k6DSTDq4pkJwOK0/fnThCqihZTVZwmUg2B/GvZHYLLf9kchbIp
qkiNVDSHxbNlMug0YEPw
=yPgM
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--
