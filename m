Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbaGOKoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:44:15 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33135 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104AbaGOKoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:44:12 -0400
Date: Tue, 15 Jul 2014 12:44:09 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Rob Herring <robh+dt@kernel.org>, David Airlie <airlied@linux.ie>,
        Randy Dunlap <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] DT: add vendor prefix for Foxlink Group
Message-ID: <20140715104408.GC6616@ulmo>
References: <1401976412-27436-1-git-send-email-boris.brezillon@free-electrons.com>
 <1401976412-27436-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Content-Disposition: inline
In-Reply-To: <1401976412-27436-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 03:53:31PM +0200, Boris BREZILLON wrote:
> Add vendor prefix for Foxlink Group.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Docu=
mentation/devicetree/bindings/vendor-prefixes.txt
> index abc3080..71c7749 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -46,6 +46,7 @@ epson	Seiko Epson Corp.
>  est	ESTeem Wireless Modems
>  eukrea  Eukr=C3=A9a Electromatique
>  excito	Excito
> +foxlink	Foxlink Group
>  fsl	Freescale Semiconductor
>  GEFanuc	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
>  gef	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
> --=20
> 1.8.3.2

Rob,

are you going to take this via the DT tree or do you want me to pick it
up along with patch 2/2? In the latter case, can I have your Acked-by?

Thierry

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxQX4AAoJEN0jrNd/PrOhX7cP/iDo+2ymOYGGAdIrGEWRg9GU
rKaEfMhWOYlbAWwhAaDMSn6Qojgbq9uGlPX2RNeyOHAaowNmyHySu9WqdxJ0AtkW
C45bQ75Qx+Oro8ShQ/p4xQj06P7e6EBgGNBywahmrbwmDDWLRVXPPrTe9a4xfFbX
NcFylN9k4QSXEOoYWOXwl5aRVSeal3C7k6LmsozhWEt43vMFB34nPusTLKPkOIFL
V/iK7vj+EneWZoN/5R677dVhUt15WSgMut0wuVzs0g3DgW6G6vRWKdq+N5MVhKsJ
adgEMiBP/gfmQ3qD2b1xXVCn2qJ5CsYa9kkPXtPWZYILkr8u/dEzqrwMVSZH5jnw
KdFOCgpHfbm8qB/pyEk9yiey3DYG0Or+0Eq0FdZbc1CDHhG9SaiPjB6ONktTEFeV
4dNoq4FgNOcSO4eOc91XroUp/NMUKV/LFxFE9CDcpVv79asedf6gzpmflf6iWMQ+
m5XwEzVMr1XYhnjkOSAM4g+uD5fdgSROPT1Hp6getoXydKcmyKXZFqN+ND5gYgEp
/49hKNuJiPQY87CxNfLLCVvND8/pO4ETCtrpx2z7CxXyYHUYtEEx5T+CFOYPkxrp
xlMKYGF0qUflDj1NuzCwOnQ4iNAyJzS5CS0E9sVQpo2CDGAIkxjGeZcmc3k7KF8n
71Qk01I1+EVhadyCVuiv
=HnAT
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
