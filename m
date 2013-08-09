Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965484Ab3HIJhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:37:08 -0400
Received: from mail.gw90.de ([188.40.100.199]:37005 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab3HIJhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:37:06 -0400
Message-ID: <1376040290.5808.3.camel@mattotaupa>
Subject: drm fixes for 3.11: Tag more patches for stable? (was: [git pull]
 drm fixes)
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Christian =?ISO-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>,
        Alex Deucher <alexdeucher@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1308090550580.3322@skynet.skynet.ie>
References: <alpine.DEB.2.00.1308090550580.3322@skynet.skynet.ie>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BL9GJ+exug0N5LZwkHy0"
Date: Fri, 09 Aug 2013 11:25:02 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.4.4-3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BL9GJ+exug0N5LZwkHy0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Dave,


Am Freitag, den 09.08.2013, 05:53 +0100 schrieb Dave Airlie:

[=E2=80=A6]

> The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a=
3f:
>=20
>   Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)
>=20
> are available in the git repository at:
>=20
>   git://people.freedesktop.org/~airlied/linux drm-fixes
>=20
> for you to fetch changes up to e42f5814212079aecd5826dba10588a896ac0862:
>=20
>   Merge tag 'drm-intel-fixes-2013-08-08' of git://people.freedesktop.org/=
~danvet/drm-intel into drm-fixes (2013-08-09 09:09:37 +1000)
>=20
> ----------------------------------------------------------------
>=20
> Aaron Lu (1):
>       drm/i915: avoid brightness overflow when doing scale
>=20
> Alex Deucher (11):
>       drm/radeon: properly handle pm on gpu reset
>       drm/radeon: select audio dto based on encoder id for DCE3
>       drm/radeon/dpm: adjust thermal protection requirements
>       drm/radeon/dpm: fix spread spectrum setup (v2)
>       drm/radeon/dpm: adjust power state properly for UVD on SI
>       drm/radeon/dpm: disable sclk ss on rv6xx
>       drm/radeon: fix audio dto calculation on DCE3+ (v3)
>       drm/radeon: always program the MC on startup
>       drm/radeon/cik: use a mutex to properly lock srbm instanced registe=
rs
>       drm/radeon/dpm: require rlc for dpm
>       drm/radeon: make missing smc ucode non-fatal
>=20
> Christian K=C3=B6nig (5):
>       drm/radeon: fix halting UVD
>       drm/radeon: only save UVD bo when we have open handles
>       drm/radeon: stop sending invalid UVD destroy msg
>       drm/radeon: add more UVD CS checking
>       drm/radeon: remove unnecessary unpin

as UVD is also in 3.10 should more of these be tagged
`stable@vger.kernel.org` too? I only checked

        drm/radeon: add more UVD CS checking

and it did not have that tag.

[=E2=80=A6]


Thanks,

Paul

--=-BL9GJ+exug0N5LZwkHy0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEABECAAYFAlIEtWIACgkQPX1aK2wOHVgoTwCfU9ixT2z4kvlVuXFN+TlqpfB3
D+UAnApxqiD7GQw/DziURgxq01kmCPlj
=Qa1x
-----END PGP SIGNATURE-----

--=-BL9GJ+exug0N5LZwkHy0--

