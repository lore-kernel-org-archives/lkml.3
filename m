Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbaJNMpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:45:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53720 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbaJNMpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:45:44 -0400
Date: Tue, 14 Oct 2014 14:45:22 +0200
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, heiko@sntech.de, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20141014124522.GU27755@sirena.org.uk>
References: <1412980506-546-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+bwwFJPg6t3ya3US"
Content-Disposition: inline
In-Reply-To: <1412980506-546-1-git-send-email-zyw@rock-chips.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: rk808: Add support setting suspend voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+bwwFJPg6t3ya3US
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2014 at 03:35:06PM -0700, Chris Zhong wrote:
> support setting suspend voltage and disable regulator in suspend.
>=20
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>

Applied, thanks.

--+bwwFJPg6t3ya3US
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUPRrhAAoJECTWi3JdVIfQNeUH/2M2FFabe+CCn7x1ouMrvR6h
vXsAUI1ABIj0gPIMH/YH0+jhLpqX4NFciJDqzJloa4hjPkdmnZPvH9PzkffOGSvw
cO60Y9PHvpyTBUAcOmo8w0g4qB/3B8VMnQ1CNjRE7Be4SP7tT9pxhiwul7yJGkEh
pDr9S7E6JEv/ZcM9r+wFnYPDl6XxA/JeQWho71wqniDWIh6AblqnHFC8qXhPvQFB
3aR5Q2/j2HQ8kf7gn5KH0XPGKopEZkvZ4aUl2MlSn3dG6Hsx4A7EiSSeC1fzIv/C
np5XOipSwXfxiBnoN33IZqttXhwNL9e2z4YM0rkxewrqFows/HuP5VADDF7tYd4=
=xhHc
-----END PGP SIGNATURE-----

--+bwwFJPg6t3ya3US--
