Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935434AbaKODed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 22:34:33 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:56467 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934378AbaKODec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 22:34:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKVbEDCyu7p0_9CHKm81j+DCqr-tToYq_KAPBieNkkwmw@mail.gmail.com>
References: <20141114204517.GA24402@www.outflux.net>
	<CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com>
	<CAGXu5jKVbEDCyu7p0_9CHKm81j+DCqr-tToYq_KAPBieNkkwmw@mail.gmail.com>
Date: Fri, 14 Nov 2014 19:34:31 -0800
X-Google-Sender-Auth: KEd9mt0inC6wZZmVjFmMJC17ufg
Message-ID: <CAE9FiQVLqh=xm+y5PwrZ1t2+PReWnN_YENMqEmEW6jMbooYi3g@mail.gmail.com>
Subject: Re: [PATCH v2] x86, mm: set NX across entire PMD at boot
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wang Nan <wangnan0@huawei.com>, David Vrabel <david.vrabel@citrix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 7:06 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Nov 14, 2014 at 5:29 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> [    0.000000]   .text: [0x01000000-0x0200d548]
>> [    0.000000] .rodata: [0x02200000-0x02a1cfff]
>> [    0.000000]   .data: [0x02c00000-0x02e50e7f]
>> [    0.000000]   .init: [0x02e52000-0x03212fff]
>> [    0.000000]    .bss: [0x03221000-0x0437bfff]
>> [    0.000000]    .brk: [0x0437c000-0x043a1fff]
>
> And which CONFIG turns on this reporting?
>

My local patch.

this brk does not shrink yet.

Yinghai
