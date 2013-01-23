Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3AWMgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:36:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab3AWMgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:36:14 -0500
Subject: Re: [ANNOUNCE] 3.8-rc4-nohz3
From: Steven Rostedt <srostedt@redhat.com>
To: sedat.dilek@gmail.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CA+icZUWuMEX7s8wvTZpA3C2-3qUjHgWM31Tefep_EU5Uj9xxLw@mail.gmail.com>
References: <CA+icZUWuMEX7s8wvTZpA3C2-3qUjHgWM31Tefep_EU5Uj9xxLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Wed, 23 Jan 2013 07:36:01 -0500
Message-ID: <1358944561.8827.57.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original email had my rostedt@goodmis.org account. Please do not use
my redhat email. It will most likely get ignored.

-- Steve


On Wed, 2013-01-23 at 12:19 +0100, Sedat Dilek wrote:
> Hi Frederic,
> 
> I wanted to 3.8-rc4-nohz3 [1] here on my Ubuntu/precise AMD64 system.
> 
> Unfortunately, the build breaks like this:
> 
> ERROR: "guest_enter" [arch/x86/kvm/kvm.ko] undefined!
> ERROR: "guest_exit" [arch/x86/kvm/kvm.ko] undefined!
> 
> This seems due to the changes in [2]:
> 
> commit 8eebafe9be5855b26baa693f96be21c4969c6fb0
> "kvm: Prepare to add generic guest entry/exit callbacks"
> 
> My kernel-config is attached!
> 
> Feel free to add any credits :-)!
> 
> Happy fixing!
> 
> Regards,
> - Sedat -
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/frederic/linux-dynticks.git;a=shortlog;h=refs/heads/3.8-rc4-nohz3
> [2] http://git.kernel.org/?p=linux/kernel/git/frederic/linux-dynticks.git;a=commitdiff;h=8eebafe9be5855b26baa693f96be21c4969c6fb0


