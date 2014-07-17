Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbaGQJyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:54:41 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:39573 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbaGQJy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:54:26 -0400
Date: Thu, 17 Jul 2014 11:54:10 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Fix comment typo 'CONFIG_SLEEP'
Message-ID: <20140717095409.GB17877@ulmo>
References: <1405590357.4808.15.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <1405590357.4808.15.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 11:45:57AM +0200, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested! Please shout if that bothers you.
>=20
> This typo entered linux-next as of today (in next-20140717). Its fix
> would be fine for the trivial tree, if trivial would track linux-next.
> But it doesn't.
>=20
>  include/linux/tegra-soc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I don't have this typo in my local tree, so I guess I must have fixed it
sometime late yesterday but then forgot push this for linux-next.

Thierry

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTx51BAAoJEN0jrNd/PrOhAtoP/0xxLqis4BgHHYM4iB8ByjUj
8FaLlXBzL6H66EdPkX0kWV/WzFfFsUne547aFk97+Hsc5Zwr1QRa0FfvOknHhhhu
rLFc95/1xggKG/sLpufY8Vkugr+ZWKcfrkdPEMvnx9ElrdoVc+bepmAajz6GOkk+
8TQ5uuvKU6yQRzzZs76ZkBDgcMW/04pwy+l1WPdX5cfKFnZ7FrBqV//lbexxZxXH
SPuZyt34gcT618s6CVfuo/3zT7OezBPOR9kV3DLYUD/rG602aU9mUMYYyZYvYkzZ
1yb1QSZmPvZTha0h6rByKzwDV3gxv+8ZecKbSBdZZk+Vc/rxl0FhePy9lLhznOMl
+oujAGuPEFfbz+R1glfXR8pjjWisk50Xhj6WnsXKgZZtSOh8u6gVM0Hf9hRP1Xjb
/nqAnJJwzdBeFgjjj3QqJUZAKW9RpxkKqEzYvx/K4NagfgfGc+Kt2BTQbKORGoyo
zAmrW+oWGnJmCM1cRjX7BF5ffy8VzDuRJNMo2LtQSZdZAgMy9ZnvPYU5VfuAfb5+
tYEN/ySL5j7Ezsh0eEvBGWLYjJF2C2Spr2G0rwNG0rTkX3Y9LAYLdlP1KIuADjuF
JeIAjOyxAlG4vTaVgJEgDAKrlMOQt5yzDIqaWVWuDi7s4E9S8ZptJQ9g7WT+zfC0
pflGTVxzRkJ7B2xS9e1t
=ZaQ4
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
