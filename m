Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934603AbaJ2RVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:21:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33505 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934130AbaJ2RVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:21:00 -0400
Message-ID: <545121DC.5050305@zytor.com>
Date: Wed, 29 Oct 2014 10:20:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: josh@joshtriplett.org, Kees Cook <keescook@chromium.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 3/3] x86: Support compiling out userspace I/O (iopl
 and ioperm)
References: <7159269982aac3b732af2c33a2e3d04e2048bdfb.1414598511.git.josh@joshtriplett.org> <9d77d0e4df8feb2cb55fb21689e016a3145cb7f8.1414598511.git.josh@joshtriplett.org> <CAGXu5jKCuWmbUgNtnVWC2JQF3ML_SQQwBMooVynsbBO8cDLudA@mail.gmail.com> <20141029171754.GA18888@cloud>
In-Reply-To: <20141029171754.GA18888@cloud>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 10:17 AM, josh@joshtriplett.org wrote:
>>
>> But this is entirely a style decision, so I leave it up to the x86
>> maintainers ...
> 
> I can certainly do that if the x86 maintainers prefer, but that tends to
> produce a net increase in lines of code, as well as duplicating all the
> function prototypes, which to me seems more error-prone.  If the
> stub versions contained any code, rather than just becoming no-ops, I'd
> definitely do that.
> 

I concur with this style choice.

>> Another nit may be that we should call this CONFIG_SYSCALL_IOPL or
>> CONFIG_SYSCALL_IOPERM in keeping with the other CONFIG_SYSCALL_*
>> naming thread? Again, I don't really care strongly beyond really
>> wanting to use this new feature! :)
> 
> I don't feel strongly about the naming.  Ingo?

It is sort of a special case here, as this reflects more than one syscall.

	-hpa


