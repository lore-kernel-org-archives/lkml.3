Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaBUQSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:18:51 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:36360 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbaBUQSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:18:49 -0500
Message-ID: <53077C5F.9000407@monstr.eu>
Date: Fri, 21 Feb 2014 17:18:39 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: balbi@ti.com
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        devicetree@vger.kernel.org, Wolfgang Denk <wd@denx.de>
Subject: Re: SPDX-License-Identifier
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local> <20140220182257.GF23217@saruman.home> <5306F458.9010706@monstr.eu> <20140221160442.GA17506@kroah.com> <5307790A.4050806@monstr.eu> <20140221161246.GM31902@saruman.home>
In-Reply-To: <20140221161246.GM31902@saruman.home>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="brFbRgBoQkFlWOGGAcHlDx0s14HCmm55Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--brFbRgBoQkFlWOGGAcHlDx0s14HCmm55Q
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/21/2014 05:12 PM, Felipe Balbi wrote:
> On Fri, Feb 21, 2014 at 05:04:26PM +0100, Michal Simek wrote:
>> On 02/21/2014 05:04 PM, Greg Kroah-Hartman wrote:
>>> On Fri, Feb 21, 2014 at 07:38:16AM +0100, Michal Simek wrote:
>>>> BTW: u-boot started to use SPDX-License-Identifier
>>>> which will be nice to start to use.
>>>
>>> I agree, feel free to start sending patches to use this type of
>>> identifier for drivers.
>>
>> But we probably need to add that Licenses to one location.
>> Documentation/Licenses?
>=20
> Just add to the drivers themselves, just like u-boot is doing. A simple=
:
>=20
> 	$ git grep -e SPDX-License-Identifier
>=20
> will tell you filename and license. Or did I misunderstand your questio=
n ?

But for doing this it is probably necessary to have location where
you will place that licenses and you will explain what it is how
it is done by Wolfgang in this commit.

http://git.denx.de/?p=3Du-boot.git;a=3Dcommitdiff;h=3Deca3aeb352c964bdb28=
b8e191d6326370245e03f

Then yes, adding one line is enough.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--brFbRgBoQkFlWOGGAcHlDx0s14HCmm55Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMHfF8ACgkQykllyylKDCGx9wCcDZZzXwHg6Ezw1RDRWt7TaPGj
zz8An0mrz5/JxUx5fyLUJzyTwFJOF2Se
=F3mL
-----END PGP SIGNATURE-----

--brFbRgBoQkFlWOGGAcHlDx0s14HCmm55Q--
