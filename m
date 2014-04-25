Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaDYFE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 01:04:56 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40741 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaDYFEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 01:04:53 -0400
Message-ID: <5359ECEC.5050902@monstr.eu>
Date: Fri, 25 Apr 2014 07:04:44 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: Re: [GIT PULL] serial: Cadence
References: <53575983.3030508@monstr.eu> <20140423234832.GB17827@kroah.com> <5358A188.4080404@monstr.eu> <20140424232332.GB10457@kroah.com>
In-Reply-To: <20140424232332.GB10457@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Fcx92oxLRspdUiRXSEeCpRfPgd3Do7Gpk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Fcx92oxLRspdUiRXSEeCpRfPgd3Do7Gpk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/25/2014 01:23 AM, Greg Kroah-Hartman wrote:
> On Thu, Apr 24, 2014 at 07:30:48AM +0200, Michal Simek wrote:
>> On 04/24/2014 01:48 AM, Greg Kroah-Hartman wrote:
>>> On Wed, Apr 23, 2014 at 08:11:15AM +0200, Michal Simek wrote:
>>>> Hi Greg,
>>>>
>>>> this is around for a while and I would like to close it.
>>>> I have applied patches 1-7 from v3.
>>>> Patches 8 and 9 should go through arm-soc tree and I will add them
>>>> to my zynq/dt branch.
>>>>
>>>> Please apply these patches to your tree.
>>>> If this should go through different tree please let me know.
>>>>
>>>> Thanks,
>>>> Michal
>>>>
>>>>
>>>> The following changes since commit c9eaa447e77efe77b7fa4c953bd62de82=
97fd6c5:
>>>>
>>>>   Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)
>>>>
>>>> are available in the git repository at:
>>>>
>>>>   git://git.monstr.eu/linux-2.6-microblaze.git tags/cadence-uart-for=
-3.16
>>>
>>> I can't take git pulles from random internet sites, sorry.  Just send=

>>> these as email and I will queue them up.
>>
>> I wouldn't say random. This repo is listed in my Microblaze maintainer=
 fragment
>> and I used signed tag and you have sign my key that's why you can easi=
ly
>> check it.
>=20
> If you have a signed key, why aren't you using git.kernel.org?  Again, =
I
> can't pull from any non-kernel.org sites, sorry.

ok. I have never had a need to have git repo at kernel.org.
But maybe I should asked for one.


>> Anyway we have sent v3 patches via email twice.
>> Origin v3:
>> https://lkml.org/lkml/2014/3/12/499
>>
>> Resent v3:
>> https://lkml.org/lkml/2014/4/4/523
>>
>> Patches 1-7 should go through your tree.
>=20
> I've now applied these, sorry for the delay.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--Fcx92oxLRspdUiRXSEeCpRfPgd3Do7Gpk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNZ7OwACgkQykllyylKDCHxNQCeOUTnbxqDOAHjyizSmBI+yL1L
p1oAn0cIpc6x8Tka/Y9akFOrzmYodnC7
=DiIE
-----END PGP SIGNATURE-----

--Fcx92oxLRspdUiRXSEeCpRfPgd3Do7Gpk--
