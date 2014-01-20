Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaATRwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:52:53 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:45377 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaATRwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:52:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAMe9rOr1nAvgurUNT8W=w1+bqcFMJw-6W5=E3O22R3RfcmPu8g@mail.gmail.com>
References: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
	<20131228163308.GA1638@infradead.org>
	<52DD6101.4010708@zytor.com>
	<20140120175033.GA11534@infradead.org>
	<CAMe9rOr1nAvgurUNT8W=w1+bqcFMJw-6W5=E3O22R3RfcmPu8g@mail.gmail.com>
Date: Mon, 20 Jan 2014 09:52:40 -0800
Message-ID: <CAMe9rOp=qrx8F2usDu0GoP7pHczAkEB8KrG=tgm6iCRjnCeELg@mail.gmail.com>
Subject: Re: [PATCH 0/8] Update kernel uabi header files for x32
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 9:51 AM, H.J. Lu <hjl.tools@gmail.com> wrote:
> On Mon, Jan 20, 2014 at 9:50 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Mon, Jan 20, 2014 at 09:46:41AM -0800, H. Peter Anvin wrote:
>>> This comment by Christoph was literally the only feedback on this
>>> patchset.  The definition of __kernel_[u]long_t is "the size of 'long'
>>> for the native kernel for the ABI".  H.J.'s patchset only affects x86
>>> (specifically x86-64) since on all other platforms __kernel_[u]long_t is
>>> simply defined as long/unsigned long.
>>
>> Btw, sorry for the delay in getting back yo your question.  How about
>> __abi_long_t or __kabi_long_t instead?
>>
>
> FWIW, in glibc, we use __syscall_ulong_t/__syscall_ulong_t instead of

It should be __syscall_ulong_t/__syscall_slong_t.

> __kernel_[u]long_t.




-- 
H.J.
