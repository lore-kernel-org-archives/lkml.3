Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbbAEVos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:44:48 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:48776 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbbAEVoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:44:46 -0500
Date: Mon, 5 Jan 2015 17:44:38 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] MAINTAINERS: Add linux-omap to list of reviewers for TI
 Thermal
Message-ID: <20150105214436.GF31536@developer>
References: <1420312410-4469-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vA66WO2vHvL/CRSR"
Content-Disposition: inline
In-Reply-To: <1420312410-4469-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vA66WO2vHvL/CRSR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 03, 2015 at 01:13:30PM -0600, Nishanth Menon wrote:
> Add linux-omap mailing list to the TI THERMAL list for wider review.
>=20
> Reported-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  MAINTAINERS |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ddb9ac8..dc9efd5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9533,6 +9533,7 @@ F:	drivers/platform/x86/thinkpad_acpi.c
>  TI BANDGAP AND THERMAL DRIVER
>  M:	Eduardo Valentin <edubezval@gmail.com>
>  L:	linux-pm@vger.kernel.org
> +L:	linux-omap@vger.kernel.org

OK. I will queue this one.

>  S:	Supported

I will also change this to random fixes too..

>  F:	drivers/thermal/ti-soc-thermal/
> =20
> --=20
> 1.7.9.5
>=20

--vA66WO2vHvL/CRSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqwW8AAoJEMLUO4d9pOJWHP8H+wXIW37g71icS28bcsQrguaC
jeJhyJd1knZ2eiJh7GrMBKtswiI4qnr1j8/y8OjUdliBnr+B38gs6T8oqazuJvql
DCCGUJ6IKNDqoAqrOS+/Eeh74QS1faOk3LUUPi957UCMuU6ictYUpBuYh8WDK99c
ev3lHt528RmwGQ0n2pSfEkD5OQbP1fSztXo4x0/XI1PkRaIUg4hk0VG8mEEPqGo5
cDVdxe82/4yADRBiowMmb6VawdNOqGAg2kwUecU8PJIw5D3TbNgtOOPHi8uGzK9p
5qVrrfIS51QzVCzd3x0aM8LeQJk1iQnSK35nua+EZyGiAwZcjmCsj7aG/9HLQAc=
=s2wk
-----END PGP SIGNATURE-----

--vA66WO2vHvL/CRSR--
