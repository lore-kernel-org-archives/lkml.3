Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaKHLAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 06:00:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58155 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbaKHLAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 06:00:06 -0500
Date: Sat, 8 Nov 2014 11:59:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Timothy McDaniel <timnboys@gmail.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Via Nano fails and completely crashes on kvm
Message-ID: <20141108105959.GA19594@pd.tnic>
References: <CALL1ybn2scmOyKom3cphHu+kzJyGv+4OGPmrwJN60GU1QhFTyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALL1ybn2scmOyKom3cphHu+kzJyGv+4OGPmrwJN60GU1QhFTyA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 10:18:32PM -0500, Timothy McDaniel wrote:
> Via Nano fails and completely crashes on kvm
> 
> here is my /proc/cpuinfo
> 
> processor       : 0
> vendor_id       : CentaurHauls
> cpu family      : 6
> model           : 15
> model name      : VIA Nano processor U2250 (1.6GHz Capable)
> stepping        : 3
> cpu MHz         : 800.000
> cache size      : 1024 KB
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat clflush acpi mmx fxsr sse sse2 ss tm pbe syscall nx lm
> constant_tsc up rep_good nopl pni monitor vmx est tm2 ssse3 cx16 xtpr
> rng rng_en ace ace_en ace2 phe phe_en lahf_lm
> bogomips        : 3191.62
> clflush size    : 64
> cache_alignment : 128
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> also here is my uname -mrs
> Linux 3.2.0-4-amd64 x86_64
> 
> here is uname -a
> Linux sd-24793 3.2.0-4-amd64 #1 SMP Debian 3.2.63-2+deb7u1 x86_64 GNU/Linux
> 
> please tell me if you need anymore info on helping me get kvm to work.

 [ Quoting the whole mail for reference. ]

Yes, please try a newer kernel first, say 3.17, for example. Then, if
it still crashes, catch everything from the crash and add it here as a
reply to this mail.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
