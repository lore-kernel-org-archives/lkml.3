Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbaFNAIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 20:08:25 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:50953 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbaFNAIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 20:08:22 -0400
MIME-Version: 1.0
In-Reply-To: <1517175.iyVMqh7r2z@vostro.rjw.lan>
References: <1402602419-27934-1-git-send-email-keescook@chromium.org>
	<1737131.VlQuirUC3S@vostro.rjw.lan>
	<CAGXu5j+BTYup-9cbwSJsKNW4R1e2QY4wVubfpC3s2LVkE4Amow@mail.gmail.com>
	<1517175.iyVMqh7r2z@vostro.rjw.lan>
Date: Fri, 13 Jun 2014 17:08:21 -0700
X-Google-Sender-Auth: xSPvwzG3NPMY0O1_zHH13-IO13c
Message-ID: <CAGXu5jJSqV2MeuofJP4OEiDytQBqKMgC3cj+tguiwTmpRX1wSQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] make kASLR vs hibernation boot-time selectable
From: Kees Cook <keescook@chromium.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Len Brown <len.brown@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 5:14 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Friday, June 13, 2014 03:59:57 PM Kees Cook wrote:
>> On Fri, Jun 13, 2014 at 3:54 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> > On Friday, June 13, 2014 03:07:19 PM Kees Cook wrote:
>
> [cut]
>
>> > I'll have a closer look at that shortly (it's been quite some time since
>> > I wrote that code).
>>
>> Thanks; I'm trying to get a test environment instrumented too so I can
>> look at this. (At the very least, it sounds like we'll still need my
>> patch series for other architectures.)
>
> How can I obtain a kernel address of the beginning of a given page
> (as represented by struct page) on x86_64 today?

I don't know off the top of my head. I've used virt_to_phys, but
things like PFN_PHYS(page_to_pfn(page)) maybe? I'm not entirely clear
which you need, but mm.h seems to have the bulk of what I've seen.

-Kees

-- 
Kees Cook
Chrome OS Security
