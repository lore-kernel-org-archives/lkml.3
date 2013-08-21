Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3HUHVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:21:30 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:34097 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3HUHV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:21:26 -0400
Message-ID: <52146A6E.5030005@monstr.eu>
Date: Wed, 21 Aug 2013 09:21:18 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Libo Chen <libo.chen@huawei.com>
CC: davem@davemloft.net, michal.simek@xilinx.com, renner@efe-gmbh.de,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 6/8] net: xilinx_emaclite: remove unnecessary dev_set_drvdata()
References: <1377068556-51316-1-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1377068556-51316-1-git-send-email-libo.chen@huawei.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="xqFx5DVG6V3hTOUi59ffxortln8LoO1oW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xqFx5DVG6V3hTOUi59ffxortln8LoO1oW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/21/2013 09:02 AM, Libo Chen wrote:
> Unnecessary dev_set_drvdata() is removed, because the driver core
> clears the driver data to NULL after device_release or on probe failure=
=2E
>=20
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/ne=
t/ethernet/xilinx/xilinx_emaclite.c
> index 7c1ccbc..4c619ea 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> @@ -1249,7 +1249,6 @@ static int xemaclite_of_remove(struct platform_de=
vice *of_dev)
>  	lp->phy_node =3D NULL;
> =20
>  	xemaclite_remove_ndev(ndev, of_dev);
> -	dev_set_drvdata(dev, NULL);
> =20
>  	return 0;
>  }
>=20

Acked-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--xqFx5DVG6V3hTOUi59ffxortln8LoO1oW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlIUam4ACgkQykllyylKDCEaVwCfYNvW/3LNhul7Mkxo5Ik2IcYd
rxwAnROcyW876sL3Z7AAanhqV2hzqnwQ
=hZmA
-----END PGP SIGNATURE-----

--xqFx5DVG6V3hTOUi59ffxortln8LoO1oW--
