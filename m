Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaIXJOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:14:30 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:54525 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaIXJOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:14:25 -0400
MIME-Version: 1.0
In-Reply-To: <1411497613-24049-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1411497613-24049-1-git-send-email-tomeu.vizoso@collabora.com>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Wed, 24 Sep 2014 11:14:03 +0200
X-Google-Sender-Auth: zO34zNWx-WA76uaW3vKwS4BAZHo
Message-ID: <CAAObsKAnf22O-3KLbpWK2sbaRu8SOmXs2WJSJF5e8uzz_Oedaw@mail.gmail.com>
Subject: Re: [PATCH v13 0/9] Per-user clock constraints
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, rabin@rab.in,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 September 2014 20:40, Tomeu Vizoso <tomeu.vizoso@collabora.com> wrote:
> Hello,
>
> this version of the patchset addresses some issues that Russell pointed out
> yesterday:

Just an update with the test build results from kbuild. I'm not sure
about the timeouts, but it can be seen that allmodconfig succeeds for
all arches except sh and sparc64, which timed out. Other configs
succeed for those arches, though.

Regards,

Tomeu

-------- Forwarded Message --------
Subject: [tomeu:clk-refactoring-13]
26c9a94cb870d0c5a10b73ac454b19df7664ed01 BUILD INCOMPLETE
Date: Wed, 24 Sep 2014 07:29:29 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>

git://git.collabora.co.uk/git/user/tomeu/linux.git  clk-refactoring-13
26c9a94cb870d0c5a10b73ac454b19df7664ed01  clk: Add docs about calling
clk_put after clk_get_parent

TIMEOUT after 300m


Sorry we cannot finish the testset for your branch within a reasonable time.
It may either be some build server is down or some build worker is busy doing
bisects. The branch will get more complete coverage and possible error reports
when our build infrastructure is restored or catches up. There will be no more
build success notification for this branch head, but you can expect reasonably
good test coverage after waiting for 1 day.

configs timed out: 105

alpha                            allyesconfig
avr32                            allyesconfig
avr32                      atngw100_defconfig
avr32                     atstk1006_defconfig
blackfin                         allyesconfig
blackfin                            defconfig
cris                             allyesconfig
frv                                 defconfig
i386                           randconfig-ha0
i386                           randconfig-ha1
i386                           randconfig-ha2
i386                           randconfig-ha3
i386                         randconfig-hsxa0
i386                         randconfig-hsxa1
i386                         randconfig-hsxa2
i386                         randconfig-hsxa3
i386                         randconfig-hsxa4
i386                         randconfig-hsxa5
i386                         randconfig-hsxa6
i386                         randconfig-hsxa7
i386                         randconfig-hsxa8
i386                         randconfig-hsxa9
i386                          randconfig-hxb0
i386                          randconfig-hxb1
i386                          randconfig-hxb2
i386                          randconfig-hxb3
i386                            randconfig-r0
i386                            randconfig-r1
i386                            randconfig-r2
i386                            randconfig-r3
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
ia64                             allyesconfig
m68k                             allyesconfig
mips                             allyesconfig
mips                                defconfig
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
parisc                           allyesconfig
powerpc                          allyesconfig
powerpc                      chroma_defconfig
powerpc               corenet64_smp_defconfig
powerpc                    gamecube_defconfig
powerpc                 linkstation_defconfig
powerpc                               mpc512x
powerpc                               powerpc
powerpc                                ppc44x
powerpc                         wii_defconfig
s390                             allyesconfig
sh                               allmodconfig
sh                               allyesconfig
sh                                  defconfig
sparc64                          allmodconfig
sparc64                          allyesconfig
sparc                            allyesconfig
tile                             allyesconfig
tile                         tilegx_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                           allyesconfig
x86_64                                    lkp
x86_64                          randconfig-c0
x86_64                          randconfig-c1
x86_64                          randconfig-c2
x86_64                          randconfig-c3
x86_64                         randconfig-ha0
x86_64                         randconfig-ha1
x86_64                         randconfig-ha2
x86_64                         randconfig-ha3
x86_64                       randconfig-hsxa0
x86_64                       randconfig-hsxa1
x86_64                       randconfig-hsxa2
x86_64                       randconfig-hsxa3
x86_64                       randconfig-hsxa4
x86_64                       randconfig-hsxa5
x86_64                       randconfig-hsxa6
x86_64                       randconfig-hsxa7
x86_64                       randconfig-hsxa8
x86_64                       randconfig-hsxa9
x86_64                        randconfig-hxb0
x86_64                        randconfig-hxb1
x86_64                        randconfig-hxb2
x86_64                        randconfig-hxb3
x86_64                          randconfig-j0
x86_64                          randconfig-j1
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
x86_64                                   rhel
xtensa                           allyesconfig

configs tested: 99

parisc                        c3000_defconfig
parisc                         b180_defconfig
parisc                              defconfig
alpha                               defconfig
parisc                            allnoconfig
x86_64                            allnoconfig
x86_64                     randconfig-c3-0924
x86_64                     randconfig-c1-0924
x86_64                     randconfig-c2-0924
x86_64                     randconfig-c0-0924
ia64                             allmodconfig
ia64                              allnoconfig
ia64                                defconfig
ia64                             alldefconfig
i386                      randconfig-ha0-0924
i386                      randconfig-ha2-0924
i386                      randconfig-ha1-0924
i386                      randconfig-ha3-0924
s390                             allmodconfig
s390                              allnoconfig
s390                                defconfig
x86_64                    randconfig-ha1-0924
x86_64                    randconfig-ha3-0924
x86_64                    randconfig-ha0-0924
x86_64                    randconfig-ha2-0924
arm                       omap2plus_defconfig
arm                                    sa1100
arm                              allmodconfig
arm                          prima2_defconfig
arm                         at91_dt_defconfig
arm                               allnoconfig
arm                                   samsung
arm                       spear13xx_defconfig
arm                         s3c2410_defconfig
arm                                  iop-adma
arm                       imx_v6_v7_defconfig
arm                                       mmp
arm                           tegra_defconfig
arm                                      arm5
arm                          marzen_defconfig
arm                                  at_hdmac
arm                                    ep93xx
arm                                        sh
arm                                     arm67
cris                 etrax-100lx_v2_defconfig
blackfin                  TCM-BF537_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin                BF526-EZBRD_defconfig
i386                     randconfig-hxb3-0924
i386                     randconfig-hxb1-0924
i386                     randconfig-hxb2-0924
i386                     randconfig-hxb0-0924
m68k                          multi_defconfig
m68k                       m5475evb_defconfig
m68k                             allmodconfig
m68k                          amiga_defconfig
mips                             allmodconfig
mips                                   jz4740
mips                              allnoconfig
mips                      fuloong2e_defconfig
mips                                     txx9
powerpc                             defconfig
powerpc                       ppc64_defconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
sh                            titan_defconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                                allnoconfig
x86_64                   randconfig-hxb2-0924
x86_64                   randconfig-hxb0-0924
x86_64                   randconfig-hxb3-0924
x86_64                   randconfig-hxb1-0924
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
xtensa                       common_defconfig
m32r                       m32104ut_defconfig
xtensa                          iss_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
m32r                     mappi3.smp_defconfig
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
microblaze                       allyesconfig
i386                             allyesconfig
i386                       randconfig-r0-0924
i386                       randconfig-r2-0924
i386                       randconfig-r3-0924
i386                       randconfig-r1-0924
x86_64                           allmodconfig
i386                              allnoconfig
i386                                defconfig
i386                             allmodconfig
i386                             alldefconfig
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot

Thanks,
Fengguang
