Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab3GDC4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 22:56:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60419 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932633Ab3GDC4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 22:56:35 -0400
Message-ID: <1372906583.22888.66.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 1/1] linux-firmware: Add AMD microcode patch firmware
 files
From: Ben Hutchings <ben@decadent.org.uk>
To: Sherry Hurwitz <sherry.hurwitz@amd.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        amd64-microcode@amd64.org
Date: Thu, 04 Jul 2013 03:56:23 +0100
In-Reply-To: <1372447651-10290-1-git-send-email-sherry.hurwitz@amd.com>
References: <1372447651-10290-1-git-send-email-sherry.hurwitz@amd.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9QKAUJ3QR4MHIltcJ60C"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9QKAUJ3QR4MHIltcJ60C
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-06-28 at 14:27 -0500, Sherry Hurwitz wrote:
> For AMD Families 10h ~ 14h Processors
> file:   amd-ucode/microcode_amd.bin
> md5sum: 55ae79b82cbfddcf7142058be3c9ec2d
>=20
> For AMD Family 15h Processors
> file:   amd-ucode/microcode_amd_fam15h.bin
> md5sum: 122ac7e56442c2b7c28eb26978b2d57c
>=20
> Signed-off-by: Sherry Hurwitz <sherry.hurwitz@amd.com>
> ---
>  LICENSE.amd-ucode                  |   64 ++++++++++++++++++++++++++++++=
++++++
>  WHENCE                             |    9 +++++
>  amd-ucode/microcode_amd.bin        |  Bin 0 -> 12684 bytes
>  amd-ucode/microcode_amd_fam15h.bin |  Bin 0 -> 7876 bytes
>  4 files changed, 73 insertions(+)
>  create mode 100644 LICENSE.amd-ucode
>  create mode 100644 amd-ucode/microcode_amd.bin
>  create mode 100644 amd-ucode/microcode_amd_fam15h.bin
[...]
> --- a/WHENCE
> +++ b/WHENCE
> @@ -2169,3 +2169,12 @@ File: go7007/wis-startrek.fw
>  Licence: Redistributable. See LICENCE.go7007_firmware for details
> =20
>  ------------------------------------------------------------------------=
--
> +
> +Driver: microcode_amd - AMD CPU Microcode Update Driver for Linux
> +
> +File: amd-ucode/microcode_amd.bin
> +File: amd-ucode/microcode_amd_fam15h.bin
> +
> +License: Redistributable. See LICENSE.amd-ucode for details
[...]

Please include the version number.

I notice that the download page on amd64.org also has GPG signatures.
Perhaps those should be included too?

(Actually, I would like to see verifiable signatures on all binary
firmware, but I don't think that can be made a requirement any time
soon.  Key 9F94BC90 isn't signed by another published key, so I still
have no reason to trust its identity.)

Ben.

--=20
Ben Hutchings
Tomorrow will be cancelled due to lack of interest.

--=-9QKAUJ3QR4MHIltcJ60C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUdTkV+e/yOyVhhEJAQqiYw//X9mwGFVp8KONeIACCA+uznU4dDGbITEL
d9acczBXAkyknt5VTi5TOPjOwZhD+j+PhrhVOVWIDjEFpytEDUjjkcR5wGecVytr
Kc4xsnVkhAKFaYEIedW0/V+8WVmcyGATDSy6Hp8O3RJA445za6Qc/zmvTpaaX/lO
GTSm4ZKhf/fCF5WzI1z+J3Op1fRdPjOEw6yfYmuHEZGT0jqIzOtTSvad/ONBD6BV
Sp5B3UnmoIjC6h50WGeO81XjvqLATiRw/ueRj9QXAZBefnCuutFz7FF/9Yjz8+hh
xuoaUBSa4Fob5RTxESTXTrx/CLdVsWAbuiKVXbFRs7DQWeZBZluQSpi6E3GZ0zk3
g5VLMnywe2QxWBVCYtRqpD2Kn0VRoYfCcS4TiTkV3/6EhNzeWj/gC2xT7TejKzcA
xcDwNkhFS2HCK8765568QJxoiPknCpRxkh+XtxjRATOzfiCJ1MKPFnTdQcoVuUsD
wa/Q1CKVno6spLRP82RbUBHwnIxTv31dvPOd1iirNqqokEKFFOJ4ldiu3lch87xn
LcNxMiqj3Ryr+y4d10xkVeh6f9B2LsyRE+zS6OYp+PlNBsukyOiZ5udNVg9hrz/7
cUVtiEJqxJahVVkBxfSZsYUxJcnhsUujgFMcAg/FzWxzAJK7wx2AJQ6khwDTyakC
HgXWNdx3ZYo=
=TCNw
-----END PGP SIGNATURE-----

--=-9QKAUJ3QR4MHIltcJ60C--
