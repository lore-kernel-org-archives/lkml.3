Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbaDGVxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 17:53:51 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49380 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaDGVxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 17:53:50 -0400
X-Nat-Received: from [202.181.97.72]:61688 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1396907211.8486
To: matt.fleming@intel.com, ak@linux.intel.com
Cc: thomas@archlinux.org, viro@zeniv.linux.org.uk, geert@linux-m68k.org,
        penguin-kernel@i-love.sakura.ne.jp, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        tpowa@archlinux.org, hpa@zytor.com
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
References: <20140407173016.GU32556@tassilo.jf.intel.com>
	<5342E46B.4080603@archlinux.org>
	<53430646.40507@archlinux.org>
	<20140407204221.GW32556@tassilo.jf.intel.com>
	<CAL01qpvjZz-XnVT+S3E5E2XGcuFoetE5cwnArYfW-TwYZVKtKw@mail.gmail.com>
In-Reply-To: <CAL01qpvjZz-XnVT+S3E5E2XGcuFoetE5cwnArYfW-TwYZVKtKw@mail.gmail.com>
Message-Id: <201404080646.BID87018.SOOVJMFOLFtQHF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 8 Apr 2014 06:46:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 07042014 #7803982, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fleming, Matt wrote:
> On 7 April 2014 21:42, Andi Kleen <ak@linux.intel.com> wrote:
> >
> > This sounds like the UEFI boot corrupts some memory?
> 
> Hmpf, yeah. I'll take a look in the morning.
> 
> Thomas, you mention you're running in a 32-bit vm earlier in this
> thread. Any chance you're using ovmf because that would make it much
> easier to track this down?
> 

I'm not familiar with UEFI boot, but it could happen because what
I experienced with BIOS boot was an address dependent behavior.

https://lkml.org/lkml/2013/9/4/188
