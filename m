Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161883Ab3DEKoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:44:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161197Ab3DEKoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:44:18 -0400
From: Thomas Renninger <trenn@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/22] x86, ACPI, numa: Parse numa info early
Date: Fri, 05 Apr 2013 12:44:15 +0200
Message-ID: <5508508.vgkavG8rFJ@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10 (Linux/3.7.10-1.1-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <CAE9FiQXE5T=8RJ0FdrMfiTwZ_NDBwjsOM0q_SePWsuQ3tXMz6Q@mail.gmail.com>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org> <2084826.BkfVPXvXDZ@skinner.arch.suse.de> <CAE9FiQXE5T=8RJ0FdrMfiTwZ_NDBwjsOM0q_SePWsuQ3tXMz6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 04, 2013 08:09:46 PM Yinghai Lu wrote:
> On Thu, Apr 4, 2013 at 7:28 PM, Thomas Renninger <trenn@suse.de> wrote:
> > On Thursday, April 04, 2013 04:46:04 PM Yinghai Lu wrote:
> >> One commit that tried to parse SRAT early get reverted before v3.9-rc1.
> >> 
> >> | commit e8d1955258091e4c92d5a975ebd7fd8a98f5d30f
> >> | Author: Tang Chen <tangchen@cn.fujitsu.com>
> >> | Date:   Fri Feb 22 16:33:44 2013 -0800
> >> | 
> >> |    acpi, memory-hotplug: parse SRAT before memblock is ready
> >> 
> >> It broke several things, like acpi override and fall back path etc.
> >> 
> >> This patchset is clean implementation that will parse numa info early.
> > 
> > I tried acpi table overriding, but it did not work for me.
> > In your tree there seem to miss acpi initrd overriding doku:
> > Documentation/acpi/initrd_table_override.txt
> 
> http://git.kernel.org/cgit/linux/kernel/git/yinghai/linux-yinghai.git/tree/D
> ocumentation/acpi/initrd_table_override.txt?h=for-x86-mm
> > And your tree is 3.6.0-rc6-default+ based, right?
> 
> It is in for-x86-mm branch, should be 3.9-rc5 based.
> 
> http://git.kernel.org/cgit/linux/kernel/git/yinghai/linux-yinghai.git/tree/D
> ocumentation/acpi/initrd_table_override.txt?h=for-x86-mm
> 
> can you try
> 
> git checkout -b for-x86-mm origin/for-x86-mm
Argh stupid, I simply put a git clone before:
could be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm

I doubt I will make it today, so I'll try to give it a test on Mo.

Thanks,

   Thomas
