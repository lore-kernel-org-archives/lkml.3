Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaJLRN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 13:13:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32863 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbaJLRNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 13:13:54 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20141012115332.5ec3db90@as>
References: <20141012114353.4aa73c00@as> <17ED2609-CA12-4842-8ECE-A1F08693FC01@zytor.com> <20141012115332.5ec3db90@as>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] x86: Clean up stack access code in irq_32.c
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 12 Oct 2014 10:13:33 -0700
To: Chuck Ebbert <cebbert.lkml@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Message-ID: <EF2BF2D8-F612-4812-AF96-05944AE0200C@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's not a justification for change.  Claiming no harm is nevessary but not sufficient.

On October 12, 2014 9:53:32 AM PDT, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
>On Sun, 12 Oct 2014 09:47:53 -0700
>"H. Peter Anvin" <hpa@zytor.com> wrote:
>
>[replying to the list this time, sigh]
>
>> We changed this to asm because the C broke some compilers.  Why are
>you changing it back?
>> 
>
>The C broke some compilers because it was using a global register
>variable. This is a local one, which the clang documentation says is
>supported. And I compiled it with clang with no problem.
>
>> On October 12, 2014 9:43:53 AM PDT, Chuck Ebbert
><cebbert.lkml@gmail.com> wrote:
>> >Use C instead of asm for accessing the stack pointer. And define
>some
>> >macros to make the code easier to understand.
>> >

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
