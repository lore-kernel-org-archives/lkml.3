Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaB0MK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:10:26 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:65237 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaB0MKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:10:25 -0500
Date: Thu, 27 Feb 2014 13:10:21 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the drm-tegra tree
Message-ID: <20140227121020.GB21422@ulmo.nvidia.com>
References: <20140227125357.795646e8ee6ea60f79423162@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <20140227125357.795646e8ee6ea60f79423162@canb.auug.org.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2014 at 12:53:57PM +1100, Stephen Rothwell wrote:
> Hi Thierry,
>=20
> After merging the drm-tegra tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/gpu/drm/tegra/sor.c: In function 'tegra_sor_init':
> drivers/gpu/drm/tegra/sor.c:924:22: error: 'TEGRA_OUTPUT_LVDS' undeclared=
 (first use in this function)
>=20
> Caused by commit 765db82ce08a ("drm/tegra: Add eDP support").
>=20
> I have used the drm-tegra tree from next-20140226 for today.

I've pushed out a fixed tree for linux-next.

Thanks,
Thierry

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDyssAAoJEN0jrNd/PrOhnjMP+wVhCCqsmTixb5c7LgD7IrdU
qncAJPRxtn7h6t3DoEKBbL1Fqo1lxgSxjzl80l6no1Yw/OSzxeFol9L0viiBc5u6
5N2I5AUfV/mVr521C5gsrQhAzfjPQ2/NslkaenmHITs17n1Q0N9D8yJ/VWKBLSyq
NhxYYMA4Y8Fz1sWjuP89uhLrsNKWofOtUF8696DA4KmeIpxRQ3k+KpERolYxGApv
jtfOkE0IQWdo7jOeUvgUAGJJnvH+8SGVsXHF9iEhXYSDPvgoidlrUXufWOmfwInJ
/nn+vXC/DsSYHWU4OiWsnlAUVoqKyYyAu17aYxcqezBJA9LreB4VxxBB6Buop9nn
xcJ8MD9RohmZcfY0FtqIoFKBDRi2u0OKQ2SwCqcHip0mHGav9i75VzjRq19/db9S
1nmnx/VhJoWBS0xkQ7bOMZH9N8swAJSYFwWOObJrCplGi7EwRGERtLI4drH/pwAd
gi4de4JBEIEtjukXmgVkBZlmjSzi11u1LoSlBmuHgrQCZkre0nkMPuNj0+V3g11e
BrpF8BUSGeVlCWMnJdwscn3kuQnFvaDDPKKEDUvIRu8iL9XN4y0kJnz7NfaJM9RK
UaVBeqZSH+GFRMGdHGzdBOW9vMlIRkZh5rT5q/GRfDwZvOtuFr3F0d6kl8Fs3Dx4
RuBl0I7LciycrZzTF+hy
=mfRh
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
