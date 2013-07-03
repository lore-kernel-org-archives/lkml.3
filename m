Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3GCGAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 02:00:31 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:45974 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab3GCGAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 02:00:30 -0400
Message-ID: <51D3BDFA.9080501@monstr.eu>
Date: Wed, 03 Jul 2013 08:00:26 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Pavel Machek <pavel@ucw.cz>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH v3 2/2] uio: Remove uio_pdrv and use uio_pdrv_genirq instead
References: <03c8973cc1e9efcd203e4d95d2dd9469afbcb39b.1372240320.git.michal.simek@xilinx.com> <771234ccdcd59f6918deb4a8690b4b435a9da556.1372240320.git.michal.simek@xilinx.com> <20130626231706.GA13166@amd.pavel.ucw.cz> <51D12DEA.1010700@monstr.eu> <20130701172024.GA25891@kroah.com>
In-Reply-To: <20130701172024.GA25891@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2MELAQJPJWWHTNCVTRDVB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2MELAQJPJWWHTNCVTRDVB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/01/2013 07:20 PM, Greg Kroah-Hartman wrote:
> On Mon, Jul 01, 2013 at 09:21:14AM +0200, Michal Simek wrote:
>> Hi Greg,
>>
>> On 06/27/2013 01:17 AM, Pavel Machek wrote:
>>> On Wed 2013-06-26 11:52:12, Michal Simek wrote:
>>>> The patch "UIO: fix uio_pdrv_genirq with device tree but no interrup=
t"
>>>> (sha1: e3a3c3a205554e564751cd9c0276b2af813d7a92)
>>>> add support to use this driver with no interrupts.
>>>> uio_pdrv_genirq also supports device-tree binding
>>>> which is not available in uio_pdrv.
>>>>
>>>> That's why this uio_pdrv driver can be just removed.
>>>>
>>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>>>
>>> Reviewed-by: Pavel Machek <pavel@denx.de>
>>
>> I see 3.10 was tagged.
>> Are you going to add this patch to your char-misc tree?
>=20
> I will consider it after 3.11-rc1 is out, it came too late in the 3.11
> merge cycle for me to take it.

No problem. I will keep my eyes on it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2MELAQJPJWWHTNCVTRDVB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHTvfoACgkQykllyylKDCGBUgCfag5LNSBNlP5yrZ+JkK8Y2zWA
29MAniuh8F3IhuB6xzxaruD7gL1uoKe9
=AYYN
-----END PGP SIGNATURE-----

------enig2MELAQJPJWWHTNCVTRDVB--
