Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaDMCy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 22:54:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:44351 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaDMCy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 22:54:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,849,1389772800"; 
   d="scan'208";a="492041514"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
Date: Sat, 12 Apr 2014 19:54:33 -0700
In-Reply-To: <CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 11 Apr 2014 11:41:01 -0700")
Message-ID: <87ppkmhrbq.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, Apr 11, 2014 at 11:27 AM, Brian Gerst <brgerst@gmail.com> wrote:
>> Is this bug really still present in modern CPUs?  This change breaks
>> running 16-bit apps in Wine.  I have a few really old games I like to
>> play on occasion, and I don't have a copy of Win 3.11 to put in a VM.
>
> Ok, so you actually do this on x86-64, and it currently works? For
> some reason I thought that 16-bit windows apps already didn't work.

No, it always worked. I spent some time on this early in the x86-64 port
and it flushed out some bugs in the early segment handling. x86-64 
is perfectly compatible to this.

Also was always proud that Linux 64 was more compatible old Windows
binaries than Win 64...

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
