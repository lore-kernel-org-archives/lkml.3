Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122Ab3DJHkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:40:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab3DJHkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:40:41 -0400
From: Thomas Renninger <trenn@suse.de>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>
Subject: Early microcode signing in secure boot environment -  Was: x86, microcode: Use common get_ramdisk_image()
Date: Wed, 10 Apr 2013 09:40:38 +0200
Message-ID: <17075291.dMPGPSzlWd@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10 (Linux/3.7.10-1.1-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <5164F9E9.3010909@cn.fujitsu.com>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org> <1365119186-23487-3-git-send-email-yinghai@kernel.org> <5164F9E9.3010909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, April 10, 2013 01:34:33 PM Tang Chen wrote:
> On 04/05/2013 07:46 AM, Yinghai Lu wrote:
> > Use common get_ramdisk_image() to get ramdisk start phys address.
> > 
> > We need this to get correct ramdisk adress for 64bit bzImage that
> > initrd can be loaded above 4G by kexec-tools.disk_size;

don't know whether this question came up when this feature got
submitted (if yes a pointer would be appreciated).

Is there a concept how signed microcode can get verified when applied early,
like it is done via firmware loader?

If not, early microcode loading is not really usable in secure boot
environment, right?

Thanks,

    Thomas
