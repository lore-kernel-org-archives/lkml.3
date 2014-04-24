Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaDXFbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 01:31:01 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41379 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaDXFa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 01:30:58 -0400
Message-ID: <5358A188.4080404@monstr.eu>
Date: Thu, 24 Apr 2014 07:30:48 +0200
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
References: <53575983.3030508@monstr.eu> <20140423234832.GB17827@kroah.com>
In-Reply-To: <20140423234832.GB17827@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="EOwMBtos0Rsh6IkbTsI2nNP9T61V8PKmh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EOwMBtos0Rsh6IkbTsI2nNP9T61V8PKmh
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/24/2014 01:48 AM, Greg Kroah-Hartman wrote:
> On Wed, Apr 23, 2014 at 08:11:15AM +0200, Michal Simek wrote:
>> Hi Greg,
>>
>> this is around for a while and I would like to close it.
>> I have applied patches 1-7 from v3.
>> Patches 8 and 9 should go through arm-soc tree and I will add them
>> to my zynq/dt branch.
>>
>> Please apply these patches to your tree.
>> If this should go through different tree please let me know.
>>
>> Thanks,
>> Michal
>>
>>
>> The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297=
fd6c5:
>>
>>   Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)
>>
>> are available in the git repository at:
>>
>>   git://git.monstr.eu/linux-2.6-microblaze.git tags/cadence-uart-for-3=
=2E16
>=20
> I can't take git pulles from random internet sites, sorry.  Just send
> these as email and I will queue them up.

I wouldn't say random. This repo is listed in my Microblaze maintainer fr=
agment
and I used signed tag and you have sign my key that's why you can easily
check it.

Anyway we have sent v3 patches via email twice.
Origin v3:
https://lkml.org/lkml/2014/3/12/499

Resent v3:
https://lkml.org/lkml/2014/4/4/523

Patches 1-7 should go through your tree.
That's why please apply these 7 patches to your tree. If you want
to get just these 7 patches as v4, please let us know we can easily
resent it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--EOwMBtos0Rsh6IkbTsI2nNP9T61V8PKmh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNYoYgACgkQykllyylKDCEZeQCcC2LTXzQusWpnOpmycB6ZcTKv
VyMAnRPm7Xcdf+3mO8ga53gJmIk+bsMz
=4rFF
-----END PGP SIGNATURE-----

--EOwMBtos0Rsh6IkbTsI2nNP9T61V8PKmh--
