Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaEADuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:50:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53544 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaEADuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:50:01 -0400
Date: Wed, 30 Apr 2014 20:49:41 -0700
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140501034941.GU3245@sirena.org.uk>
References: <1398163650-19367-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sDhuxz86kt5qlkuV"
Content-Disposition: inline
In-Reply-To: <1398163650-19367-1-git-send-email-geert@linux-m68k.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Add missing initialization of this_page
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sDhuxz86kt5qlkuV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2014 at 12:47:29PM +0200, Geert Uytterhoeven wrote:
> drivers/base/regmap/regmap.c: In function =E2=80=98_regmap_range_multi_pa=
ged_reg_write=E2=80=99:
> drivers/base/regmap/regmap.c:1665: warning: =E2=80=98this_page=E2=80=99 m=
ay be used uninitialized in this function
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> This may be a false positive, if "range" is guaranteed to be non-zero
> during the first iteration of the loop

Applied, though with this sort of thing it's generally a bit better to
do the init at the start of the loop rather than at declaration - init
at declaration is a common pattern for just shutting up warnings as
opposed to analyisng to make sure that there's really not an issue.

--sDhuxz86kt5qlkuV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYcRSAAoJELSic+t+oim978YP/il2RwkAD0MVwaU4Ue+XmXrQ
Bqc0kHcm94ix4+uYDmARnA3MXswMg7FZi5JBIicUvN8tWibN4PapUEyYF1xL8ITi
5OU7H8o0r+8E/hsD9v2RaT8Qi2iDRTTGMT7oVSfo2Fc2gffYG1B0s34UcJW3crpZ
MGEm1LlvVnTYT1anh9IoBn31l0IbeZX9Uu4uz780o0rljNzNsONBL2voU98xLjif
ZIj21COOOclxkSKenyHoD1uYe23PrpNNoRKDqYM5kQGC7IHVzR3Z+8fTtF2EHV3e
cY/LAFQXldcEwSBSFniD0P9Xd/kI5Xu/jVZDM5E4eF5piFqDynQAxNvFxJOboc4a
fs6ZwYPVW8uy123CHfWi8oK7s1e33OS3ATM2J6EtxA4+ok0JEoRRmJcCq3XoQi0p
xDxi96vUFCWGRW7AbZ5sQU+YV3Zelshwwq7eaoDtvqjuuqYQaOpsYlXN0EqyBDKx
cWfpOSPGtd3nwOIA2vbxfBXLiTtOriNNDTP7OrvpIM6BmSYH3cwTMFoqqg5dp2I1
nLk8bM2L4DW3Pe+XwvBJbevg3H+Y+H78WgIMHmhgUTLP8mlZp+t3xXqbgYEz2sNC
FEL8N+8/z+GCuJMUJAsEI2VHH1xQ+yEeu/JUhcyQQuBW3n34U1gRwFgNJ1D8VAZu
ghaipoZT2f/lspKvICzQ
=JvHU
-----END PGP SIGNATURE-----

--sDhuxz86kt5qlkuV--
