Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbaBUR0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:26:19 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:56296 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbaBUR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:26:17 -0500
Message-ID: <53078C30.7060703@monstr.eu>
Date: Fri, 21 Feb 2014 18:26:08 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        devicetree@vger.kernel.org, Wolfgang Denk <wd@denx.de>
Subject: Re: SPDX-License-Identifier
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local> <20140220182257.GF23217@saruman.home> <5306F458.9010706@monstr.eu> <20140221160442.GA17506@kroah.com> <5307790A.4050806@monstr.eu> <20140221161246.GM31902@saruman.home> <53077C5F.9000407@monstr.eu> <20140221162045.GN31902@saruman.home> <20140221165633.GA5465@kroah.com>
In-Reply-To: <20140221165633.GA5465@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="sVUURwXO8G1cO9er7ujFXgQ2S7tU3E3oM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sVUURwXO8G1cO9er7ujFXgQ2S7tU3E3oM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/21/2014 05:56 PM, Greg Kroah-Hartman wrote:
> On Fri, Feb 21, 2014 at 10:20:45AM -0600, Felipe Balbi wrote:
>> Hi,
>>
>> On Fri, Feb 21, 2014 at 05:18:39PM +0100, Michal Simek wrote:
>>> On 02/21/2014 05:12 PM, Felipe Balbi wrote:
>>>> On Fri, Feb 21, 2014 at 05:04:26PM +0100, Michal Simek wrote:
>>>>> On 02/21/2014 05:04 PM, Greg Kroah-Hartman wrote:
>>>>>> On Fri, Feb 21, 2014 at 07:38:16AM +0100, Michal Simek wrote:
>>>>>>> BTW: u-boot started to use SPDX-License-Identifier
>>>>>>> which will be nice to start to use.
>>>>>>
>>>>>> I agree, feel free to start sending patches to use this type of
>>>>>> identifier for drivers.
>>>>>
>>>>> But we probably need to add that Licenses to one location.
>>>>> Documentation/Licenses?
>>>>
>>>> Just add to the drivers themselves, just like u-boot is doing. A sim=
ple:
>>>>
>>>> 	$ git grep -e SPDX-License-Identifier
>>>>
>>>> will tell you filename and license. Or did I misunderstand your ques=
tion ?
>>>
>>> But for doing this it is probably necessary to have location where
>>> you will place that licenses and you will explain what it is how
>>> it is done by Wolfgang in this commit.
>>>
>>> http://git.denx.de/?p=3Du-boot.git;a=3Dcommitdiff;h=3Deca3aeb352c964b=
db28b8e191d6326370245e03f
>>>
>>> Then yes, adding one line is enough.
>>
>> spdx.org has all licenses, why don't we just rely on that instead of
>> adding every other license to the kernel source ?
>=20
> Yes, all that will be acceptable is a one-line identifier in the file.
> No need to have all the different licenses in the kernel source, that's=

> crazy and not needed at all.
>
> I've told the SPDX people this in the past, and they keep promising tha=
t
> they will do the comment work, but it's been months and I have yet to
> see a single patch...

But shouldn't we at least write somewhere
that it has connection to spdx.org where you can find out that licenses.

I have no problem to use this one-line identifier at all.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--sVUURwXO8G1cO9er7ujFXgQ2S7tU3E3oM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMHjDAACgkQykllyylKDCFDRwCfbIM70ia5M3IKxYQQXI1haszJ
rIYAmwQfK5LnKHsEwJNtd2cMdPtlSWk/
=+OFf
-----END PGP SIGNATURE-----

--sVUURwXO8G1cO9er7ujFXgQ2S7tU3E3oM--
