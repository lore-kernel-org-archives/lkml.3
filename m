Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab3FCOd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:33:27 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:59425 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758476Ab3FCOdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:33:24 -0400
Message-ID: <51ACA928.4090601@monstr.eu>
Date: Mon, 03 Jun 2013 16:33:12 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org,
        Graeme Smecher <gsmecher@threespeedlogic.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] xilinx systemace: Fix device name assignment for
 SystemACE (from "xs`" to "xsa").
References: <4b5d6615a1338145a461a6d4e1c7d3e42d4f4522.1369312303.git.michal.simek@xilinx.com> <51AC9068.7050203@monstr.eu> <20130603142242.GB7024@kroah.com>
In-Reply-To: <20130603142242.GB7024@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2BKBFJVSJOLTQVTGXAMKK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2BKBFJVSJOLTQVTGXAMKK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/03/2013 04:22 PM, Greg Kroah-Hartman wrote:
> On Mon, Jun 03, 2013 at 02:47:36PM +0200, Michal Simek wrote:
>> Hi Greg,
>>
>> do you want to take these two patches through your tree?
>=20
> Why would I be sending in drivers/block/* patches?  I don't have a tree=

> for that, do I?

Ah ok. I took you because you are 3rd based on get_maintainer patch (50% =
commit signer)


>> Or should I take them through my microblaze tree?
>=20
> Please do, or send them to the block maintainer.

Who is drivers/block maintainer? I can't see anyone in MAINTAINERS file.

I should probably also change systemace record too.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2BKBFJVSJOLTQVTGXAMKK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGsqSgACgkQykllyylKDCGBtACfVGAF/Nm9duQOpVpXLLfduJkK
ZmkAn0rjcfF9wwwPRnKNqTDLLixGUDXS
=TxO3
-----END PGP SIGNATURE-----

------enig2BKBFJVSJOLTQVTGXAMKK--
