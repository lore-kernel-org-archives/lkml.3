Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbaCDBdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 20:33:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33203 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbaCDBds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 20:33:48 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1393885748.5094.14.camel@deneb.redhat.com>
References: <1392238575-10000-1-git-send-email-msalter@redhat.com> <1393337404.7307.51.camel@deneb.redhat.com> <20140225183012.GA27164@mudshark.cambridge.arm.com> <1393353942.26583.10.camel@deneb.redhat.com> <530CF21E.1020603@zytor.com> <1393885748.5094.14.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v4 0/6] generic early_ioremap support
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 03 Mar 2014 17:30:16 -0800
To: Mark Salter <msalter@redhat.com>
CC: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Dave Young <dyoung@redhat.com>, Rob Herring <robherring2@gmail.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Message-ID: <2d10d2d3-02e3-42b6-9b81-464f56e4cf01@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All three .

On March 3, 2014 2:29:08 PM PST, Mark Salter <msalter@redhat.com> wrote:
>On Tue, 2014-02-25 at 11:42 -0800, H. Peter Anvin wrote:
>> On 02/25/2014 10:45 AM, Mark Salter wrote:
>> > On Tue, 2014-02-25 at 18:30 +0000, Will Deacon wrote:
>> >> I'd suggest spitting the core part out from the arch-specific
>parts. That
>> >> way, the core part can merged independently and architectures can
>move over
>> >> as they see fit. It also signals (at least to me) that, "hey, I
>should
>> >> probably review this" whilst my current stance is "there's a whole
>load of
>> >> stuff under mm/ that needs to be acked first".
>> >>
>> >> If you put the whole thing into next, you just run the risk of
>conflicts
>> >> with all the arch trees.
>> > 
>> > I've been thinking of breaking out the common bits and x86 bits and
>just
>> > going with that for now. There's no point in just doing the common
>bits
>> > because it won't get tested without at least one architecture using
>it.
>> > 
>> 
>> If you think it makes sense we could take the common bits + x86 and
>put
>> them through the -tip tree.  The other option would be to put the
>whole
>> thread in linux-next with Acks.
>> 
>> As far as x86 is concerned it looks like it is mostly just code
>> movement, so I'm happy giving my:
>> 
>> Acked-by: H. Peter Anvin <hpa@linux.intel.com>
>> 
>
>I going to send out a v5 with the arm bits dropped and Ack-bys added.
>There is still some work left there, so I think I'll redo the arm bits
>separately after once the common bits are in the kernel.
>
>Peter, is your Acked-by only for "[3/6] x86: use generic
>early_ioremap"?
>Or did you intend "[1/6] x86/mm: sparse warning fix for early_memremap"
>and/or "[2/6] mm: create generic early_ioremap() support" also?

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
