Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3DKHbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:31:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab3DKHbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:31:36 -0400
From: Thomas Renninger <trenn@suse.de>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Early microcode signing in secure boot environment -  Was: x86, microcode: Use common get_ramdisk_image()
Date: Thu, 11 Apr 2013 09:31:34 +0200
Message-ID: <1478755.iNa1PauEka@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10 (Linux/3.7.10-1.1-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712205594BABA@ORSMSX105.amr.corp.intel.com>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org> <17075291.dMPGPSzlWd@skinner.arch.suse.de> <3E5A0FA7E9CA944F9D5414FEC6C712205594BABA@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 10, 2013 05:47:25 PM Yu, Fenghua wrote:
> > -----Original Message-----
> > From: Thomas Renninger [mailto:trenn@suse.de]
> > Sent: Wednesday, April 10, 2013 12:41 AM
> > Hello,
> > 
> > On Wednesday, April 10, 2013 01:34:33 PM Tang Chen wrote:
> > > On 04/05/2013 07:46 AM, Yinghai Lu wrote:
> > > > Use common get_ramdisk_image() to get ramdisk start phys address.
> > > > 
> > > > We need this to get correct ramdisk adress for 64bit bzImage that
> > > > initrd can be loaded above 4G by kexec-tools.disk_size;
> > 
> > don't know whether this question came up when this feature got
> > submitted (if yes a pointer would be appreciated).
> > 
> > Is there a concept how signed microcode can get verified when applied
> > early,
> > like it is done via firmware loader?
> > 
> > If not, early microcode loading is not really usable in secure boot
> > environment, right?
> 
> The microcode is cryptographically authenticated by the CPU itself, so there
> is no security issue related to early microcode loading.

So Intel HW is allowed to authenticate its firmware itself, bypassing the UEFI
certificates...
Does this apply for other vendors as well?
Does this apply to secure boot specification?

Is this "cryptographically authenticated by the CPU itself" thing documented
somewhere so that security people can double check that it is really
secure?

Just some questions to discuss and think about...

      Thomas
