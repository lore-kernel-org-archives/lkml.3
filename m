Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaCMPyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:54:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39184 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbaCMPym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:54:42 -0400
Message-ID: <5321D45C.7040504@zytor.com>
Date: Thu, 13 Mar 2014 08:53:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Stefani Seibold <stefani@seibold.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] x86, vdso32: handle 32 bit vDSO larger one page
References: <1394664680-17799-1-git-send-email-stefani@seibold.net> <1394664680-17799-4-git-send-email-stefani@seibold.net> <5320E689.7060607@zytor.com> <CALCETrXQJvkk-5ncSgTyoy9sCN0AT+h9-1F6wAnxqRm242PjrQ@mail.gmail.com>
In-Reply-To: <CALCETrXQJvkk-5ncSgTyoy9sCN0AT+h9-1F6wAnxqRm242PjrQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 03:59 PM, Andy Lutomirski wrote:
> 
> Note that this code is completely unnecessary if either of my patch
> sets is accepted.  Since you're the maintainer, can you give an
> opinion? :)
> 

I'm trying to unwind all the patches going around, Linus' feedback and
so on, and figure out what this means in concrete terms especially in
the light of the 3.15 merge window coming up.

I tried to apply your patchset "[PATCH v2 0/2] x86: Relocate the compat
vdso per process" on top of tip:x86/vdso, but it conflicts pretty hard
-- I guess you are using a different baseline, but that makes it
complicated to deal with.

Otherwise, it seems the logical way forward.  Could you and/or Stefani
work out the conflicts between the patchsets?

In the meantime I'm going to apply Stefani's first patch.

	-hpa

