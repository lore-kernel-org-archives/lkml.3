Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaDDFQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 01:16:34 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:60886 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaDDFQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 01:16:33 -0400
Message-ID: <533E4028.7040505@monstr.eu>
Date: Fri, 04 Apr 2014 07:16:24 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Insop Song <Insop.Song@gainspeed.com>, Paul Bolle <pebolle@tiscali.nl>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'insop.song@gmail.com'" <insop.song@gmail.com>
Subject: Re: [GIT PULL] Staging driver patches for 3.15-rc1
References: <20140401184817.GA21855@kroah.com> <1396427043.18431.20.camel@x220> <20140402200428.GE26966@kroah.com> <7731bd53be4b49e2924a7002f74dc090@BY2PR07MB011.namprd07.prod.outlook.com> <20140402230837.GA24324@kroah.com>
In-Reply-To: <20140402230837.GA24324@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="d9jGXqO4gUX3OA3ppH8Tq2532Kx9EMfpj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--d9jGXqO4gUX3OA3ppH8Tq2532Kx9EMfpj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/03/2014 01:08 AM, Greg KH wrote:
> On Wed, Apr 02, 2014 at 08:52:18PM +0000, Insop Song wrote:
>> On Wed, April 02, 2014 1:04 PM, Greg KH wrote:
>>> On Wed, Apr 02, 2014 at 10:24:03AM +0200, Paul Bolle wrote:
>>>> On Tue, 2014-04-01 at 11:48 -0700, Greg KH wrote:
>>>>> Staging driver pull request for 3.15-rc1
>>>>>
>>>>> Here's the huge drivers/staging/ update for 3.15-rc1.
>>>>>
>>>>> Loads of cleanup fixes, a few drivers removed, and some new ones
>>> added.
>>>>>
>>>>> All have been in linux-next for a while.
>>>>>
>>>>> [...]
>>>>>
>>>>> Insop Song (1):
>>>>>       staging: fpgaboot: Xilinx FPGA firmware download driver
>>>>
>>>> This commit adds checks for CONFIG_B4860G100. Is a patch to add a
>>>> Kconfig symbol B4860G100 perhaps queued somewhere?
>>>
>>> Insop, I thought this config option was coming from some other place,=
 right?
>>>
>>
>> Paul,
>> I didn't include CONFIG_B4860G100 in Kconfig in original patch set,
>> since programming FPGA method can vary in different system, and this
>> was discussed during the review with Greg as well.
>>
>> However, actual fpga programming method is well contained in io.c with=

>> ifdef-ed CONFIG_B4860G100, now I think I might better to update
>> Kconfig to include CONFIG_B4860G100.
>>
>> Greg, what do you think? Any harm to add custom board CONFIG* to
>> staging Kconfig? Let me know.
>=20
> Let's see what it would look like and we can go from there.

That's interesting driver. Maybe good time to refresh my work
around fpga manager.
http://permalink.gmane.org/gmane.linux.kernel/1573330

It is the framework which just provides what you have done there.

I need to finish some work and let me look at it next week.
It should be easy for you to switch to it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--d9jGXqO4gUX3OA3ppH8Tq2532Kx9EMfpj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM+QCgACgkQykllyylKDCF1dwCdEtd/GvbjtSBKkT9x0qquui90
8vIAn3jTUtlFWq9pAqauWwnlmZzsqWo8
=zuaX
-----END PGP SIGNATURE-----

--d9jGXqO4gUX3OA3ppH8Tq2532Kx9EMfpj--
