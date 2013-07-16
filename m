Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702Ab3GPV7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:59:14 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:37756 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201Ab3GPV7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:59:12 -0400
MIME-Version: 1.0
In-Reply-To: <51E5A207.30204@zytor.com>
References: <1373659660-31123-1-git-send-email-keescook@chromium.org>
	<20130712203802.GA14702@www.outflux.net>
	<CAE9FiQWJin8-hXsodo46vhYPMrWiiboEVQySPO-LgXtebYmUzw@mail.gmail.com>
	<CAGXu5jJs5ve-31AYKbv6EaV5PKCf5cOEeWTRsYsi_kBbLWj5uQ@mail.gmail.com>
	<51E5A0A9.90108@zytor.com>
	<CAGXu5jJJXgnJxuvc851UZ4Du10HSBJnDWc7rKgRb4_=ojMmtug@mail.gmail.com>
	<51E5A207.30204@zytor.com>
Date: Tue, 16 Jul 2013 14:59:11 -0700
X-Google-Sender-Auth: H53Hs4VhK1KNTUYIl7QoCtFe0m4
Message-ID: <CAE9FiQUW2QTkmT=n3jnL_s09wrSBU5u9rvzNKvCUzcz6pVEgWw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] x86, boot: add mmio serial during compressed boot
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 12:41 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/16/2013 12:40 PM, Kees Cook wrote:
>>>
>>> I think setting up a dynamic #PF handler is the right thing for the
>>> decompressor, we already did for the kernel proper.
>>
>> I'm not sure how to accomplish this yet. I'm still trying to
>> understand how the page tables are arranged. :)
>>
>
> Look at the handler at the top of arch/x86/kernel/head64.c.

could extract code from arch/x86/kernel/{head64.c, head_64.S},
and share them with arch/x86/boot/compressed/{misc.c, head_64.S}

Yinghai
