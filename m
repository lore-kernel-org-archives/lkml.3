Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaIWJSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:18:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:26597 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428AbaIWJSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:18:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,578,1406617200"; 
   d="scan'208";a="479398204"
Message-ID: <542139E6.2030806@intel.com>
Date: Tue, 23 Sep 2014 17:14:14 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <jdelvare@suse.de>,
        "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: Re: [PATCH] i2c: move acpi code back into the core
References: <1411420006-4713-1-git-send-email-wsa@the-dreams.de> <5420CEC9.1030400@intel.com> <20140923053951.GA1411@katana> <54211C96.3030608@intel.com>
In-Reply-To: <54211C96.3030608@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月23日 15:09, Lan Tianyu wrote:
> On 2014年09月23日 13:39, Wolfram Sang wrote:
>>
>>> Sorry for later response due to sickness. I can't write this patch in
>>> time. Sorry again. I will test it soon.
>>
>> Oh, get well soon! Please say so next time, so I know.
>>
> 
> Thanks. OK.
> I have put the patch into test system and need to wait some time.
> 

Hi Wolfram:
The patch passed through the following 110 configure build test in the
0-day build test system.


configs tested: 110

mips                             allmodconfig
mips                                   jz4740
mips                              allnoconfig
mips                      fuloong2e_defconfig
mips                                     txx9
x86_64                            allnoconfig
sh                            titan_defconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                                allnoconfig
x86_64                     randconfig-c3-0923
x86_64                     randconfig-c1-0923
x86_64                     randconfig-c2-0923
x86_64                     randconfig-c0-0923
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
parisc                        c3000_defconfig
parisc                         b180_defconfig
parisc                              defconfig
alpha                               defconfig
parisc                            allnoconfig
powerpc                  iss476-smp_defconfig
powerpc                 mpc8315_rdb_defconfig
mips                          ath79_defconfig
arm                             bcm_defconfig
powerpc                   gef_ppc9a_defconfig
i386                      randconfig-ha0-0923
i386                      randconfig-ha1-0923
i386                      randconfig-ha2-0923
i386                      randconfig-ha3-0923
ia64                             allmodconfig
ia64                              allnoconfig
ia64                                defconfig
ia64                             alldefconfig
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
microblaze                       allyesconfig
s390                             allmodconfig
s390                              allnoconfig
s390                                defconfig
x86_64                    randconfig-ha1-0923
x86_64                    randconfig-ha3-0923
x86_64                    randconfig-ha0-0923
x86_64                    randconfig-ha2-0923
xtensa                       common_defconfig
m32r                       m32104ut_defconfig
xtensa                          iss_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
m32r                     mappi3.smp_defconfig
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
i386                             allyesconfig
cris                 etrax-100lx_v2_defconfig
blackfin                  TCM-BF537_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin                BF526-EZBRD_defconfig
i386                       randconfig-r0-0923
i386                       randconfig-r2-0923
i386                       randconfig-r3-0923
i386                       randconfig-r1-0923
x86_64                 randconfig-s0-09231616
x86_64                 randconfig
Hi Wolfram:
	The patch passed through the following 110 configure build test in the
0-day build test system.-s1-09231616
x86_64                           allmodconfig
i386                             alldefconfig
i386                             allmodconfig
i386                              allnoconfig
i386                                defconfig
i386                     randconfig-x009-0922
x86_64                   randconfig-x003-0922
x86_64                   randconfig-x004-0922
i386                     randconfig-x006-0922
x86_64                   randconfig-x001-0922
i386                     randconfig-x005-0922
x86_64                   randconfig-x006-0922
i386                     randconfig-x001-0922
i386                     randconfig-x004-0922
i386                     randconfig-x003-0922
i386                     randconfig-x000-0922
x86_64                   randconfig-x002-0922
x86_64                   randconfig-x008-0922
i386                     randconfig-x008-0922
i386                     randconfig-x007-0922
x86_64                   randconfig-x009-0922
x86_64                   randconfig-x000-0922
x86_64                   randconfig-x007-0922
i386                     randconfig-x002-0922
x86_64                   randconfig-x005-0922
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot


-- 
Best regards
Tianyu Lan
