Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaBCHBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 02:01:46 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:38828 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaBCHBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 02:01:44 -0500
Message-ID: <52EF3ECF.4010006@monstr.eu>
Date: Mon, 03 Feb 2014 08:01:35 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 10/10] watchdog: xilinx: Enable this driver for Zynq
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <f7bdfada576e93eaab8f6dc2ecd881da8f43911c.1391177880.git.michal.simek@xilinx.com> <52EBB897.6040300@roeck-us.net>
In-Reply-To: <52EBB897.6040300@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="CHMQCE3TcgjouOKnVOiOtpA1V5NeXRPLi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CHMQCE3TcgjouOKnVOiOtpA1V5NeXRPLi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/31/2014 03:52 PM, Guenter Roeck wrote:
> On 01/31/2014 06:18 AM, Michal Simek wrote:
>> Enable this driver for Zynq.
>> Move it to architecture independent Kconfig part.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>> Build tested by zero day testing system.
>> ---
>>   drivers/watchdog/Kconfig | 22 +++++++++-------------
>>   1 file changed, 9 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
>> index 9db5d3c..6120403 100644
>> --- a/drivers/watchdog/Kconfig
>> +++ b/drivers/watchdog/Kconfig
>> @@ -111,6 +111,15 @@ config WM8350_WATCHDOG
>>         Support for the watchdog in the WM8350 AudioPlus PMIC.  When
>>         the watchdog triggers the system will be reset.
>>
>> +config XILINX_WATCHDOG
>> +    tristate "Xilinx Watchdog timer"
>> +    select WATCHDOG_CORE
>=20
> This needs to depend on HAS_IOMEM.

Are you sure?
I have no problem to do this change.
Zero day testing system doesn't report any problem with it.

I have checked dependencies and only score, tile and um has NO_IOMEM opti=
on
enables. And below in log is tile with allyesconfig that's why I believe
this driver has been also tested without any issue.

Thanks,
Michal


git://git.monstr.eu/linux-2.6-microblaze  xnext/watchdog
f7bdfada576e93eaab8f6dc2ecd881da8f43911c  watchdog: xilinx: Enable this d=
river for Zynq

elapsed time: 81m

configs tested: 122

alpha                               defconfig
parisc                            allnoconfig
parisc                         b180_defconfig
parisc                        c3000_defconfig
parisc                              defconfig
arm                               allnoconfig
arm                               almodconfig
arm                         at91_dt_defconfig
arm                       imx_v6_v7_defconfig
arm                          marzen_defconfig
arm                       omap2plus_defconfig
arm                          prima2_defconfig
arm                         s3c2410_defconfig
arm                       spear13xx_defconfig
arm                           tegra_defconfig
m32r                       m32104ut_defconfig
m32r                     mappi3.smp_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
xtensa                       common_defconfig
xtensa                          iss_defconfig
x86_64                            allnoconfig
sh                                allnoconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                            titan_defconfig
x86_64                     randconfig-c0-0131
x86_64                     randconfig-c1-0131
x86_64                     randconfig-c2-0131
x86_64                     randconfig-c3-0131
x86_64                     randconfig-c4-0131
x86_64                     randconfig-c5-0131
x86_64                     randconfig-c6-0131
x86_64                     randconfig-c7-0131
x86_64                     randconfig-c8-0131
x86_64                     randconfig-c9-0131
x86_64                           allyesconfig
alpha                            allyesconfig
avr32                            allyesconfig
blackfin                         allyesconfig
cris                             allyesconfig
ia64                             allyesconfig
m68k                             allyesconfig
mips                             allyesconfig
parisc                           allyesconfig
powerpc                          allyesconfig
s390                             allyesconfig
sh                               allyesconfig
sparc                            allyesconfig
sparc64                          allyesconfig
tile                             allyesconfig
xtensa                           allyesconfig
ia64                             alldefconfig
ia64                             allmodconfig
ia64                              allnoconfig
ia64                                defconfig
x86_64                                    lkp
powerpc                      chroma_defconfig
powerpc               corenet64_smp_defconfig
powerpc                    gamecube_defconfig
powerpc                 linkstation_defconfig
powerpc                         wii_defconfig
x86_64                     randconfig-j0-0131
x86_64                     randconfig-j1-0131
x86_64                     randconfig-j2-0131
x86_64                     randconfig-j3-0131
x86_64                     randconfig-j4-0131
x86_64                     randconfig-j5-0131
m68k                             allmodconfig
m68k                          amiga_defconfig
m68k                       m5475evb_defconfig
m68k                          multi_defconfig
blackfin                BF526-EZBRD_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                  TCM-BF537_defconfig
cris                 etrax-100lx_v2_defconfig
i386                       randconfig-r0-0131
i386                       randconfig-r1-0131
i386                       randconfig-r2-0131
i386                       randconfig-r3-0131
i386                       randconfig-r4-0131
i386                       randconfig-r5-0131
s390                             allmodconfig
s390                              allnoconfig
s390                                defconfig
i386                             allyesconfig
x86_64                           allmodconfig
i386                             alldefconfig
i386                             allmodconfig
i386                              allnoconfig
i386                                defconfig
x86_64                        randconfig-x000
x86_64                        randconfig-x001
x86_64                        randconfig-x002
x86_64                        randconfig-x003
x86_64                        randconfig-x004
x86_64                        randconfig-x005
x86_64                        randconfig-x006
x86_64                        randconfig-x007
x86_64                        randconfig-x008
x86_64                        randconfig-x009
i386                          randconfig-x000
i386                          randconfig-x001
i386                          randconfig-x002
i386                          randconfig-x003
i386                          randconfig-x004
i386                          randconfig-x005
i386                          randconfig-x006
i386                          randconfig-x007
i386                          randconfig-x008
i386                          randconfig-x009
powerpc                          allmodconfig
powerpc                           allnoconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot
microblaze                       allyesconfig
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig



--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--CHMQCE3TcgjouOKnVOiOtpA1V5NeXRPLi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLvPtMACgkQykllyylKDCEzHQCggeSXVRmkEx45WmOp9vmsIPIZ
EmkAmQEWP6fzCmyFyxNLJn/ViHElB7YJ
=iKcA
-----END PGP SIGNATURE-----

--CHMQCE3TcgjouOKnVOiOtpA1V5NeXRPLi--
