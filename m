Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab3KZKgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:36:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:9542 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab3KZKgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:36:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,773,1378882800"; 
   d="scan'208";a="440045668"
Date: Tue, 26 Nov 2013 18:37:19 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: WARNING: CPU: 0 PID: 1 at init/main.c:711 do_one_initcall()
Message-ID: <20131126103719.GG17626@yliu-dev.sh.intel.com>
References: <20131122060223.GP9991@yliu-dev.sh.intel.com>
 <529329DE.4010709@panasas.com>
 <20131125132542.GX9991@yliu-dev.sh.intel.com>
 <52935754.1070208@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52935754.1070208@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 03:57:40PM +0200, Boaz Harrosh wrote:
> On 11/25/2013 03:25 PM, Yuanhan Liu wrote:
> > 
> > Hi Boaz,
> > 
> > We are running an 0day kernel testing system. We will test all developers'
> > tree we tracked in our system automatically. And obviously, linux-open-osd
> > is in that list.
> > 
> > This system can't tell whether a branch is experimental unless
> > - You put one extra line of "Dont-Auto-Build" to the head commit log.
> > 
> > - the branch name contains "experimental", say exofs_ioctl-experimental
> > 
> > If both items aren't convenient to you, you can ask us to remove your
> > tree from that list. Then you will never get report like this from us.
> > However, you may lose a chance to find build, boot and performance bug
> > automatically for you ;)
> > 
> > 	--yliu
> > 
> 
> 
> Ha OK very cool. I will remember to put -experimental on the branch name
> this is fine I will do it ASAP.
> 
> Thanks so much. Do you have some web based info on the build system?

Sorry, nope.

> Do you have a place I can see test results and tests summery?

If you like, I can add you into the build-notify list. Once the build
finished, you might get an email like following:

	--yliu

----
From: kbuild test robot <fengguang.wu@intel.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [yuanhan:branch] a828a375f9fcc422c8d2613d774d031fa8a02a97 BUILD SUCCESS

git://bee.sh.intel.com/git/yliu/linux.git  branch
a828a375f9fcc422c8d2613d774d031fa8a02a97  branch: commit summary

elapsed time: 262m

configs tested: 189

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
avr32                      atngw100_defconfig
avr32                     atstk1006_defconfig
frv                                 defconfig
m68k                          amiga_defconfig
m68k                       m5475evb_defconfig
m68k                          multi_defconfig
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
tile                         tilegx_defconfig
um                                  defconfig
x86_64                             acpi-redef
x86_64                     randconfig-a0-1105
x86_64                     randconfig-a1-1105
x86_64                     randconfig-a2-1105
x86_64                     randconfig-a3-1105
x86_64                     randconfig-a4-1105
x86_64                     randconfig-a5-1105
i386                       randconfig-c0-1105
i386                       randconfig-c1-1105
i386                       randconfig-c2-1105
i386                       randconfig-c3-1105
i386                       randconfig-c4-1105
i386                       randconfig-c5-1105
i386                       randconfig-c6-1105
i386                       randconfig-c7-1105
i386                       randconfig-c8-1105
i386                       randconfig-c9-1105
x86_64                     randconfig-c0-1105
x86_64                     randconfig-c1-1105
x86_64                     randconfig-c2-1105
x86_64                     randconfig-c3-1105
x86_64                     randconfig-c4-1105
x86_64                     randconfig-c5-1105
x86_64                     randconfig-c6-1105
x86_64                     randconfig-c7-1105
x86_64                     randconfig-c8-1105
x86_64                     randconfig-c9-1105
ia64                             alldefconfig
ia64                             allmodconfig
ia64                              allnoconfig
ia64                                defconfig
mips                             allmodconfig
mips                              allnoconfig
mips                      fuloong2e_defconfig
i386                     randconfig-i000-1105
i386                     randconfig-i001-1105
i386                     randconfig-i002-1105
i386                     randconfig-i003-1105
i386                     randconfig-i004-1105
i386                     randconfig-i005-1105
i386                     randconfig-i006-1105
i386                     randconfig-i007-1105
i386                     randconfig-i008-1105
i386                     randconfig-i009-1105
powerpc                      chroma_defconfig
powerpc               corenet64_smp_defconfig
powerpc                    gamecube_defconfig
powerpc                 linkstation_defconfig
powerpc                         wii_defconfig
sparc                               defconfig
sparc64                          allmodconfig
sparc64                           allnoconfig
sparc64                             defconfig
x86_64                           allyesconfig
x86_64                   randconfig-x000-1104
x86_64                   randconfig-x001-1104
x86_64                   randconfig-x002-1104
x86_64                   randconfig-x003-1104
x86_64                   randconfig-x004-1104
x86_64                   randconfig-x005-1104
x86_64                   randconfig-x006-1104
x86_64                   randconfig-x007-1104
x86_64                   randconfig-x008-1104
x86_64                   randconfig-x009-1104
i386                     randconfig-x000-1104
i386                     randconfig-x001-1104
i386                     randconfig-x002-1104
i386                     randconfig-x003-1104
i386                     randconfig-x004-1104
i386                     randconfig-x005-1104
i386                     randconfig-x006-1104
i386                     randconfig-x007-1104
i386                     randconfig-x008-1104
i386                     randconfig-x009-1104
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
um                               allyesconfig
xtensa                           allyesconfig
x86_64                           allyesdebian
x86_64                                    lkp
x86_64               lkp-CONFIG_DEBUG_MUTEXES
x86_64                lkp-CONFIG_DEBUG_RODATA
x86_64                 lkp-CONFIG_SCHED_DEBUG
x86_64                  lkp-CONFIG_SCSI_DEBUG
x86_64                                nfsroot
x86_64                     randconfig-j0-1105
x86_64                     randconfig-j1-1105
x86_64                     randconfig-j2-1105
x86_64                     randconfig-j3-1105
x86_64                     randconfig-j4-1105
x86_64                     randconfig-j5-1105
x86_64                     randconfig-j6-1105
x86_64                     randconfig-j7-1105
x86_64                     randconfig-j8-1105
x86_64                     randconfig-j9-1105
blackfin                BF526-EZBRD_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                  TCM-BF537_defconfig
cris                 etrax-100lx_v2_defconfig
m32r                       m32104ut_defconfig
m32r                     mappi3.smp_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
sh                                allnoconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                            titan_defconfig
xtensa                       common_defconfig
xtensa                          iss_defconfig
i386                       randconfig-r0-1105
i386                       randconfig-r1-1105
i386                       randconfig-r2-1105
i386                       randconfig-r3-1105
i386                       randconfig-r4-1105
i386                       randconfig-r5-1105
i386                       randconfig-r6-1105
i386                       randconfig-r7-1105
i386                       randconfig-r8-1105
i386                       randconfig-r9-1105
alpha                               defconfig
parisc                            allnoconfig
parisc                         b180_defconfig
parisc                        c3000_defconfig
parisc                              defconfig
s390                             allmodconfig
s390                              allnoconfig
s390                                defconfig
x86_64                            allnoconfig
i386                             allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
x86_64                           allmodconfig
i386                       randconfig-x0-1105
i386                       randconfig-x1-1105
i386                       randconfig-x2-1105
i386                       randconfig-x3-1105
i386                       randconfig-x4-1105
i386                       randconfig-x5-1105
i386                       randconfig-x6-1105
i386                       randconfig-x7-1105
i386                       randconfig-x8-1105
i386                       randconfig-x9-1105
x86_64                     randconfig-x0-1105
x86_64                     randconfig-x1-1105
x86_64                     randconfig-x2-1105
x86_64                     randconfig-x3-1105
x86_64                     randconfig-x4-1105
x86_64                     randconfig-x5-1105
x86_64                     randconfig-x6-1105
x86_64                     randconfig-x7-1105
x86_64                     randconfig-x8-1105
x86_64                     randconfig-x9-1105

Thanks,
Fengguang
