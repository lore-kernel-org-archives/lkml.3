Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaLWFmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 00:42:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:33720 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbaLWFmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 00:42:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="432434264"
Message-ID: <1419313322.26403.57.camel@intel.com>
Subject: Re: [LKP]  [drm/fb] 6cadd306033:
From: Huang Ying <ying.huang@intel.com>
To: Thierry Reding <treding@nvidia.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, LKP ML <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 23 Dec 2014 13:42:02 +0800
In-Reply-To: <1419313251.26403.56.camel@intel.com>
References: <1419313251.26403.56.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, similar information for 4a91ebc4ec70e83a2fbca622653da22bf8afda7b
too.

Best Regards,
Huang, Ying

On Tue, 2014-12-23 at 13:40 +0800, Huang Ying wrote:
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit 6cadd306033e70b4edb136815807060e168cac67 ("drm/fb-helper: Propagate errors from initial config failure")
> 
> 
> testbox/testcase/testparams: vm-kbuild-yocto-ia32/boot/1
> 
> drm-intel/topic/  6cadd306033e70b4edb1368158  
> ----------------  --------------------------  
>        fail:runs  %reproduction    fail:runs
>            |             |             |    
>            :10         100%          10:10    kmsg.drm:cirrus_modeset_init]*ERROR*cirrus_fbdev_init_failed
>            :10         100%          10:10    kmsg.cirrus#:#:#:Fatal_error_during_modeset_init
>           1:10         -10%            :10    kmsg.Initramfs_unpacking_failed:junk_in_compressed_archive
>           1:10         -10%            :10    kmsg.BUG:kernel_boot_hang
>           1:10         -10%            :10    dmesg.Initramfs_unpacking_failed
>           1:10         -10%            :10    dmesg.BUG:kernel_boot_hang
>            :2           50%           1:2     kmsg.BUG:kernel_test_crashed
>            :2          100%           2:2     kmsg.APIC_calibration_not_consistent_with_PM-Timer:#ms_instead_of#ms
>            :2           50%           1:2     kmsg.i6300esb:Unexpected_close,not_stopping_watchdog
>            :2           50%           1:2     dmesg.BUG:kernel_test_crashed
> 
> vm-kbuild-yocto-ia32: qemu-system-x86_64 -enable-kvm -cpu Westmere
> Memory: 320M
> 
> 
> To reproduce:
> 
> 	apt-get install ruby ruby-oj
> 	git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
> 	cd lkp-tests
> 	bin/setup-local job.yaml # the job file attached in this email
> 	bin/run-local   job.yaml
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> 
> Thanks,
> Huang, Ying
> 
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
> _______________________________________________ LKP mailing list LKP@lists.01.org https://lists.01.org/mailman/listinfo/lkp


