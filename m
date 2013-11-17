Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3KQQCG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:02:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56150 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab3KQQB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:01:58 -0500
Date: Sun, 17 Nov 2013 17:01:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Francis Moreau <francis.moro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131117160126.GG27323@pd.tnic>
References: <52888F6D.6000802@gmail.com>
 <20131117132531.GB27696@pd.tnic>
 <5288E5BF.2020608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5288E5BF.2020608@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 04:50:23PM +0100, Francis Moreau wrote:
> AFAIK, the kernel has 2 simple patches on top of the vanilla one.
> They're both are trivial and can't be related to this issue.
> 
> You can have look to them here:
> https://wiki.archlinux.org/index.php/Kernels#Official_packages

Ok.

> Assuming that I'm running an upstream kernel, it's almost 100%
> reproductible.

Is there any chance you can catch the whole oops, esp. keep the Code:
line complete?

Also, can you do:

$ objdump -d vmlinux | less

then search for 'call_timer_fn' and paste the whole function somewhere.

Also, can you catch a full dmesg and upload that somewhere too?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
