Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170Ab3BTGj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:39:56 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:36206 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3BTGjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:39:54 -0500
MIME-Version: 1.0
In-Reply-To: <20130219154128.GA15608@gmail.com>
References: <20130219154128.GA15608@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Feb 2013 22:39:33 -0800
X-Google-Sender-Auth: lVDiSTShJV0QPVFFR_T6wMBZqIs
Message-ID: <CA+55aFxn=xFGhF8L2pJYP8wOe3VdCpGtaibB0bbRuH8FAKkCNg@mail.gmail.com>
Subject: Re: [GIT PULL] x86/platform changes for v3.9
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 7:41 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please pull the latest x86-platform-for-linus git tree from:

Hmm.

My main desktop just had a reboot failure - it just got stuck at the
end, not powering down, and not rebooting like it should have.

This is *not* necessarily the pull that caused it, but 8f55cea410db
rebooted cleanly, and 1a13c0b181f2 did not. That implies that it's one
of your pull requests. The pulls I did in between are:

 - scheduler (with the dyntick and cputime accounting)

 - smp-hotplug-for-linus: stop_machine preparatory patches from Thomas..

 - timers-core-for-linus. Hmm..

 - x86-apic-for-linus: certainly possibly causing problems at shutdown..

 - x86-asm-for-linus: sounds unlikely, but who knows..

 - x86-boot-for-linus: shouldn't affect shutdown, but..

 - x86-build-for-linus: _really_ shouldn't affect shutdown..

 - x86-cleanups-for-linus: unlikely

 - x86-hyperv-for-linus: no, not a hyperv user ;)

 - x86-platform-for-linus: rebooting is a platform thing, but none of
this seems relevant

 - x86-uv-for-linus: not likely relevant.

I'm not going to bisect it right now, hoping that somebody goes "Hmm,
maybe it's xyzzy". And maybe it was just a one-time event, but I don't
recall having had that whole "reboot fails" case on this machine
before. Any ideas?

                              Linus
