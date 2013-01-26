Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3AZKCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 05:02:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60187 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052Ab3AZKCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 05:02:13 -0500
Date: Sat, 26 Jan 2013 18:02:06 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <v-stehle@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: debugfs: Fix compilation warning
Message-ID: <20130126100205.GJ30594@opensource.wolfsonmicro.com>
References: <1358779015-25735-1-git-send-email-v-stehle@ti.com>
 <20130122064121.GC1766@opensource.wolfsonmicro.com>
 <50FE64C8.8040407@ti.com>
 <20130123155834.GD4565@opensource.wolfsonmicro.com>
 <51010908.5090105@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45wMVEkw4XUbiYON"
Content-Disposition: inline
In-Reply-To: <51010908.5090105@ti.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45wMVEkw4XUbiYON
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 24, 2013 at 11:12:24AM +0100, Vincent Stehl=E9 wrote:

> If you mean "am I sure the loop iterates at least once", then yes, as
> we have an explicit check just before the concerned list_for_each_entry():

So, I hadn't realised this was triggered by a new compiler version -
Arnd just tried the same bodge.  I've committed a workaround for the
compiler which avoids the problems that setting 0 will have and allows
the flow analyis to run where it can.

--45wMVEkw4XUbiYON
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA6mTAAoJELSic+t+oim9T98P/3uJArmNppdJg9HOy3yU1gLU
/vlJ71JfW4WgooDhxiE2/H/D9tKNfdKE1A+92SpNUljaVju5ltxXC+RPYmibcFH0
FWXIW3F8P+gDd5xrnNuDHojLje/A06RYKwnw8WaETIs1c+ZKD+onQYeOEGCmAhqp
GTypFsnOAkNXQbAoxOIRr+Edp+xpVClxj71eI1fZUmUYfI953Ei12mDVV08aC6Yj
Aoy59F0wAa0CIzsgMMooaoBXNB+EYuGoNfBwjKDAGrM9/ec5MRmtgbIMEl+okQpR
vqpN/N6aIFGrJuEnPZ9Etq48FfonyEjQyxqVXNu4K5cZXccDPhqSyMxbVLVn+PxV
9xpDNYOetOAtwOxar92Ah8hut8gXndEZ5sDixI5JbC5O1gIt8FwmN/sWrG5ocxyq
R8gDC4qmJsgDNVMu7zwXPOLqoksMbCnQjewGDJa2swED8KuXuZAgZUvV515F4m3p
PS4ha1k9E27i7bK+XMRoLPI/0TFZYf6ZsYzVMCsY6ShrPRo/92Cbgc0MYRSqjJ7P
ehoZ0idw6cp0tnjAFyEAxp9rZnOV2rhyZGOc3c6E0SKEtM8ZkiDKywqcsLc+AXbA
mHzudotO7RphQFMbJFbIKka0Ti4oaLivigO23/JsKgXr1m0mwnqRudps1wHVR5/F
ZIjiMRrXDQaGYMA9UvDM
=gFN2
-----END PGP SIGNATURE-----

--45wMVEkw4XUbiYON--
