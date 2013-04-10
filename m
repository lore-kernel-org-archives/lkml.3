Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937226Ab3DJRr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:47:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:45146 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936357Ab3DJRr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:47:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,449,1363158000"; 
   d="scan'208";a="284393066"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Early microcode signing in secure boot environment -  Was: x86,
 microcode: Use common get_ramdisk_image()
Thread-Topic: Early microcode signing in secure boot environment -  Was:
 x86, microcode: Use common get_ramdisk_image()
Thread-Index: AQHONb60g0rx3Qsj60u0yQfcUn2kTpjPqqxQ
Date: Wed, 10 Apr 2013 17:47:25 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205594BABA@ORSMSX105.amr.corp.intel.com>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
 <1365119186-23487-3-git-send-email-yinghai@kernel.org>
 <5164F9E9.3010909@cn.fujitsu.com> <17075291.dMPGPSzlWd@skinner.arch.suse.de>
In-Reply-To: <17075291.dMPGPSzlWd@skinner.arch.suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Thomas Renninger [mailto:trenn@suse.de]
> Sent: Wednesday, April 10, 2013 12:41 AM
> Hello,
> 
> On Wednesday, April 10, 2013 01:34:33 PM Tang Chen wrote:
> > On 04/05/2013 07:46 AM, Yinghai Lu wrote:
> > > Use common get_ramdisk_image() to get ramdisk start phys address.
> > >
> > > We need this to get correct ramdisk adress for 64bit bzImage that
> > > initrd can be loaded above 4G by kexec-tools.disk_size;
> 
> don't know whether this question came up when this feature got
> submitted (if yes a pointer would be appreciated).
> 
> Is there a concept how signed microcode can get verified when applied
> early,
> like it is done via firmware loader?
> 
> If not, early microcode loading is not really usable in secure boot
> environment, right?

The microcode is cryptographically authenticated by the CPU itself, so there is no security issue related to early microcode loading.

Thanks.

-Fenghua

