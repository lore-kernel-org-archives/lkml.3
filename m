Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbaFJVf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:35:29 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:44362 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbaFJVf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:35:27 -0400
MIME-Version: 1.0
In-Reply-To: <53977885.8010709@zytor.com>
References: <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>
 <tip-bdfb9bcc25005d06a9c301830bdeb7ca5a0b6ef7@git.kernel.org>
 <20140610135051.c3c34165f73d67d218b62bd9@linux-foundation.org> <53977885.8010709@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 10 Jun 2014 14:35:05 -0700
Message-ID: <CALCETrW9axkj0P8SHO-0gWR5gQBayoY5eVqdr+MMJQEQfG94DQ@mail.gmail.com>
Subject: Re: [tip:x86/vdso] x86, vdso: Use <tools/le_byteshift.h> for
 littleendian access
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "tip-bot for H. Peter Anvin" <tipbot@zytor.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 2:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/10/2014 01:50 PM, Andrew Morton wrote:
>> On Fri, 6 Jun 2014 15:00:29 -0700 "tip-bot for H. Peter Anvin" <tipbot@zytor.com> wrote:
>>
>>> Commit-ID:  bdfb9bcc25005d06a9c301830bdeb7ca5a0b6ef7
>>> Gitweb:     http://git.kernel.org/tip/bdfb9bcc25005d06a9c301830bdeb7ca5a0b6ef7
>>> Author:     H. Peter Anvin <hpa@linux.intel.com>
>>> AuthorDate: Fri, 6 Jun 2014 14:30:37 -0700
>>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>>> CommitDate: Fri, 6 Jun 2014 14:54:54 -0700
>>>
>>> x86, vdso: Use <tools/le_byteshift.h> for littleendian access
>>
>> Getting closer.
>>
>> In file included from arch/x86/vdso/vdso2c.c:80:
>> arch/x86/vdso/vdso2c.h: In function 'go64':
>> arch/x86/vdso/vdso2c.h:119: warning: implicit declaration of function 'htole16'
>> /tmp/cc04m2KE.o: In function `go':
>> vdso2c.c:(.text+0xf69): undefined reference to `htole16'
>> vdso2c.c:(.text+0x12e6): undefined reference to `htole16'
>>
>
> Want to test this patch before I commit it?
>

Nice :)  I guess I was a bit unnecessarily zealous in the endian
conversion stuff.

--Andy
