Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3AWLy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:54:58 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64913 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab3AWLy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:54:56 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWuMEX7s8wvTZpA3C2-3qUjHgWM31Tefep_EU5Uj9xxLw@mail.gmail.com>
References: <CA+icZUWuMEX7s8wvTZpA3C2-3qUjHgWM31Tefep_EU5Uj9xxLw@mail.gmail.com>
Date: Wed, 23 Jan 2013 12:54:55 +0100
Message-ID: <CA+icZUXzQgxBokwOmyx5+e8rLNCkoz6ea=YoPA7=BT+iENWj8g@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8-rc4-nohz3
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 12:19 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> Hi Frederic,
>
> I wanted to 3.8-rc4-nohz3 [1] here on my Ubuntu/precise AMD64 system.
>
> Unfortunately, the build breaks like this:
>
> ERROR: "guest_enter" [arch/x86/kvm/kvm.ko] undefined!
> ERROR: "guest_exit" [arch/x86/kvm/kvm.ko] undefined!
>

Looks like you tested with CONFIG_KVM=y (as module fails!).

- Sedat -

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
