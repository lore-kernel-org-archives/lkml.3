Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaCMPW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:22:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43506 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbaCMPW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:22:27 -0400
Date: Thu, 13 Mar 2014 10:20:24 -0500
From: Felipe Balbi <balbi@ti.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH][next] phy: core: make NULL a valid phy reference if
 !CONFIG_GENERIC_PHY
Message-ID: <20140313152024.GF4599@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394709073-1980-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="924gEkU1VlJlwnwX"
Content-Disposition: inline
In-Reply-To: <1394709073-1980-1-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--924gEkU1VlJlwnwX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2014 at 01:11:13PM +0200, Grygorii Strashko wrote:
> This fixes a regression on Keystone 2 platforms caused by patch
> 57303488cd37da58263e842de134dc65f7c626d5
> "usb: dwc3: adapt dwc3 core to use Generic PHY Framework" which adds
> optional support of generic phy in DWC3 core.
>=20
> On Keystone 2 platforms the USB is not working now because
> CONFIG_GENERIC_PHY isn't set and, as result, Generic PHY APIs stubs
> return -ENOSYS always. The log shows:
>  dwc3 2690000.dwc3: failed to initialize core
>  dwc3: probe of 2690000.dwc3 failed with error -38
>=20
> Hence, fix it by making NULL a valid phy reference in Generic PHY
> APIs stubs in the same way as it was done by the patch
> 04c2facad8fee66c981a51852806d8923336f362 "drivers: phy: Make NULL
> a valid phy reference".
>=20
> CC: Kishon Vijay Abraham I <kishon@ti.com>
> CC: Felipe Balbi <balbi@ti.com>
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

nice :-)

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--924gEkU1VlJlwnwX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTIcy4AAoJEIaOsuA1yqREE8YQAKIoMrFLDDUEPvdarfhQCN23
PSsXaIYt4N7r2FRi3g3k0bnVLLrqJs+8Pfa8VCuNG5RP8mXLxyRGlVILzab56ueI
mlBG7+0QW/tPIObznj30eUo0JwFZmKvEzLz/h4SXpTGs5ZYYJS2+C/vFHk6AIX3h
Idok3vfs8re9yc74eYwEmhaJ9zEBIT6ORh4fFrocrNVZh3p1ZcTd8p+8voiFIEaT
MBTfmHPTPePszJRzt4GE2IQC2NDO/Tt0NIkwKrMphPynRGD+XgRYcLDFX56ULHaT
muILN9IcJhQiPET5YJPu8TXbWljNxjidL0j9JCleKjf9NdhJPMY+56Mi97X+x1MK
ILVujN6ZJdA6+EhULxkSUz/3pnjsJ5aIrzaJcE+qnW6yDbvyRQ1gZp2JD1KZTHE6
AzrOT39DPZfTFQv4PmjRn58sf77oBtgFM2hoBbDJzPf3iL9pZ4k+ZZCKXgzS0Stl
b2a6QcVushOGJrNfk5f9H1NZ1j1TZWdxCzXS1Xu6cjgaMp8NSfPQtRFxyzhs+3xD
O0cc/QlpHeOf2sU4IivS8/KLsAzkWZrftyF2CVu7UJqPNbpFRC82xb++Q56kBpqV
AEPr9laSpNVdQSnx5I7cl3kaHEXYCNy4m6GwY8AfscVDk7zgQ9soJb2bGr0n0JEg
kow+REBpxu3nBoqiOasW
=+3I/
-----END PGP SIGNATURE-----

--924gEkU1VlJlwnwX--
