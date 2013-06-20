Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab3FTP4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:56:38 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:59903 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab3FTP4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:56:34 -0400
Message-ID: <51C3262E.80407@monstr.eu>
Date: Thu, 20 Jun 2013 17:56:30 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 0/2] Extend multi_v7_defconfig
References: <1371664384-24974-1-git-send-email-soren.brinkmann@xilinx.com> <201306192046.41005.arnd@arndb.de> <51C291D0.6000401@monstr.eu> <201306201002.01702.arnd@arndb.de> <51C2BD00.4000800@monstr.eu> <5ab196fe-de67-4d75-a722-c084517a948a@CO9EHSMHS003.ehs.local>
In-Reply-To: <5ab196fe-de67-4d75-a722-c084517a948a@CO9EHSMHS003.ehs.local>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2WKDQCAGEMSQGAIWDMMMC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2WKDQCAGEMSQGAIWDMMMC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/20/2013 05:41 PM, S=C3=B6ren Brinkmann wrote:
> On Thu, Jun 20, 2013 at 10:27:44AM +0200, Michal Simek wrote:
>> On 06/20/2013 10:02 AM, Arnd Bergmann wrote:
>>> On Thursday 20 June 2013, Michal Simek wrote:
>>>> On 06/19/2013 08:46 PM, Arnd Bergmann wrote:
>>>>> On Wednesday 19 June 2013, Soren Brinkmann wrote:
>>>>>> I don't know how much a defconfig is supposed to provide, hence as=
 RFC.
>>>>>> This patches are needed for booting Zynq into a minimum ramfs base=
d
>>>>>> system with a serial console.
>>>>>
>>>>> In my opinion we should provide enable all the platform specific dr=
ivers
>>>>> in the defconfigs, as well as everything needed to boot the system,=

>>>>> to get proper compile coverage as well as the ability to test chang=
es
>>>>> easily. Your patches look good. Michal, would you apply them and
>>>>> send another pull request or should I just take them directly?
>>>>
>>>> Soren asked me 2 days ago if make sense to create zynq defconfig or =
not.
>>>> I just suggested him to better extend this multi_v7_defconfig.
>>>> But still question is if we can/should create zynq specific defconfi=
g?
>>>> Or are you going to remove all of these platform specific defconfig?=

>>>
>>> We don't have a consistent policy across platforms at the moment.
>>> Traditionally we had multiple defconfigs per platform, in some cases
>>> one per board, but moving towards one defconfig per platform at
>>> the moment.
>>
>> That's what I though but on the other hand in this process
>> all these defconfigs should be removed.
>>
>>> I guess whether or not to have a separate defconfig for one platform
>>> or to use only multi_*_defconfig is a question of how many people
>>> would use a zynq_defconfig in practice.
>>
>> The point is if you look at zynq users than they will just use this zy=
nq_defconfig
>> because they know that it is for zynq and also they don't want to
>> compile drivers for other platforms which zynq can't use.
>> From distribution point of view they want to use only one image becaus=
e it is just
>> easier.
>>
>> Based on this if there is an option to also add just zynq defconfig, I=
 would prefer
>> to also add it.
>>
>>>> Definitely agree that multi_v7 defconfig should enable everything ne=
eded
>>>> to boot the system.
>>>> Does it also mean that we should also enable all zynq drivers
>>>> to get better compile coverage?
>>>
>>> I would say yes.
>>>
>>> My feeling is that multi_v7_defconfig should enable all hardware
>>> support for the platforms in it, and that users would take it
>>> as a starting point if they want to have a configuration for
>>> an embedded system, disabling everything they don't need.
>>
>> I just wanted to be sure because you wrote just drivers for booting
>> it means any "minimal" configuration to get it boot not all drivers.
>>
>> If you are ok, Soren will prepare also specific zynq defconfig file
>> and check if there are any missing drivers which are not enabled for z=
ynq
>> for multi_v7. I will collect them in one branch and will send pull req=
uest.
> I can check. But I don't think it makes too much sense currently. Even
> though multi_v7_defconfig targets several SOCs its pretty minimal. I
> think there are just a few SOC BSPs and serial drivers selected. Due to=

> lacking driver support in mainline, a Zynq specific config would not be=

> that different, IMHO.
> But this does hopefully change with growing driver support for Zynq in
> mainline.

It depends. Kernel with all possible drivers for all arm multiplatform
could be big and also it will take a lot of time to compile it.

It is more up to Arnd and Olof.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2WKDQCAGEMSQGAIWDMMMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHDJi4ACgkQykllyylKDCEczACfZCYbEVfbS87FvaQ6hfB/qRL0
e0sAn2pCL/pMereAjalnELERwbFaEAFf
=xgcT
-----END PGP SIGNATURE-----

------enig2WKDQCAGEMSQGAIWDMMMC--
