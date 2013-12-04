Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3LDKDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:03:19 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:49638 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab3LDKDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:03:16 -0500
Date: Wed, 4 Dec 2013 11:02:14 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, swarren@wwwdotorg.org,
        linux-usb@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy-tegra-usb.c: wrong pointer check for remap UTMI
Message-ID: <20131204100214.GT19943@ulmo.nvidia.com>
References: <1386122564-4246-1-git-send-email-chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lzfPtAjrR1KYNfg0"
Content-Disposition: inline
In-Reply-To: <1386122564-4246-1-git-send-email-chris.ruehl@gtsys.com.hk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lzfPtAjrR1KYNfg0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 04, 2013 at 10:02:44AM +0800, Chris Ruehl wrote:
> usb: phy-tegra-usb.c: wrong pointer check for remap UTMI
>=20
> A wrong pointer was used to test the result of devm_ioremap()
>=20
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
>  drivers/usb/phy/phy-tegra-usb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Thierry Reding <treding@nvidia.com>

--lzfPtAjrR1KYNfg0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnv2mAAoJEN0jrNd/PrOheQgP/iOJBZYnhUHhM7Vq/KTLMuWB
qIrTPPIl+gm1a9f8kmuaxLWDVqBDR8ECB9dD2zdjquAoXF4HWj8OJyTLt40bwlke
PPrvcyHXPHv8Q/A/RZWZvXvt1FnVoQYn0dobc/1ZoViNo7a92SmFCJfaPuQLcA9l
Q4/SjtizMkVFfVyZ0DJhxQXsPaHrbFuk+s8zTr75KTqjMvt2TGU67oA7DngcrmbV
nVrnSkKiUIqux3XI8nmoakdt045mM37NOjs17cbHg/R5Gj5DI2rfpHBPSlH4RGz2
TEhNhDOwhkpQYzO+PjrfYKirIrw79nCYx2i5aLVQF39Epg/mU3GLIff+iWwXCXpc
D+MASJ/stFxdcDvQwXbh1mzStk7L2p8SipDKSEbjHPjvqlbTCLbPNJel/SRsKuiZ
jJ/2tsVTULKpFoRAJyAgYs3mhxROEw1jFD1BnPVlhRPPqPbtXaFbTM3Vq37T5bwf
gq6BHLyL0AyS95Ldrt3+M+hScMphKPv5vvzufYrx+/8OHAv3kDyFHGXSjkWt3vZ+
CXZdzQsSoPFjkWGEaYwIA21EGnqWxXo9mKRq8GwiJBlS3KdpHBH5jOwXxt+HrC14
YkzYA2P32opweUrbjNXy1zd7JUSKlFg7l3ICAfX5RU4eaHJkWgYV/TGSJA0Pdyfx
+nhKm7U45ohXUJz/d2qR
=wQp6
-----END PGP SIGNATURE-----

--lzfPtAjrR1KYNfg0--
