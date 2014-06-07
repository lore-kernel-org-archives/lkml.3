Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaFGVwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 17:52:32 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:41653 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaFGVwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 17:52:31 -0400
MIME-Version: 1.0
In-Reply-To: <201406072059.s57KxsIp025789@terminus.zytor.com>
References: <201406072059.s57KxsIp025789@terminus.zytor.com>
Date: Sat, 7 Jun 2014 14:52:30 -0700
X-Google-Sender-Auth: 7lY4u9YL8oZ77kH9_HSwBPmVViM
Message-ID: <CA+55aFzTfFm3_7htQJ8uScxcf1bSrmZ8=C65rYEq5_7BHBrnJw@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>,
        Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2014 at 1:59 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> A significantly larger than I'd like set of patches for just below the
> wire.  All of these, however, fix real problems.  However, if you feel
> it is too scary we can do it for the merge window and rely on pushing
> them into -stable.

Ugh. I really don't like the timing, but the patches themselves look
ok. So I ended up pulling them into my 3.15 branch, even if it's just
a day before release.

I'm really hoping they've gone through all the regular x86 build/boot
test machinery..

            Linus
