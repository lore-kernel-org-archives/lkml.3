Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab3HSHJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 03:09:15 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:43588 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3HSHJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 03:09:13 -0400
Message-ID: <5211C492.8060505@monstr.eu>
Date: Mon, 19 Aug 2013 09:09:06 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: David Miller <davem@davemloft.net>, michal.simek@xilinx.com,
        renner@efe-gmbh.de, Greg KH <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH RESEND 7/8] net: xilinx_emaclite: use platform_{get,set}_drvdata()
References: <5208E22C.4090101@huawei.com> <520AFC20.7050006@huawei.com>
In-Reply-To: <520AFC20.7050006@huawei.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="KvGxcBBUEr2V6bdjADDpB86svD6nsDSCU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KvGxcBBUEr2V6bdjADDpB86svD6nsDSCU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/14/2013 05:40 AM, Libo Chen wrote:
>=20
> We can use the wrapper functions platform_{get,set}_drvdata() instead o=
f
> dev_{get,set}_drvdata() with &of_dev->dev, it is convenient for user.
>=20
> Also, unnecessary dev_set_drvdata() is removed, because the driver core=

> clears the driver data to NULL after device_release or on probe failure=
=2E
>=20
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Acked-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--KvGxcBBUEr2V6bdjADDpB86svD6nsDSCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlIRxJIACgkQykllyylKDCHXMwCfbpJ2lV11A2lpqBK7A6mw9br7
sSgAoIn84jIwKgVfr1jXmn9bYr4jgX+7
=uxKG
-----END PGP SIGNATURE-----

--KvGxcBBUEr2V6bdjADDpB86svD6nsDSCU--
