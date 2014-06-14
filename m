Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaFMX4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 19:56:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51929 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754189AbaFMX4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 19:56:47 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kees Cook <keescook@chromium.org>
Cc: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Len Brown <len.brown@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/2] make kASLR vs hibernation boot-time selectable
Date: Sat, 14 Jun 2014 02:14:15 +0200
Message-ID: <1517175.iyVMqh7r2z@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGXu5j+BTYup-9cbwSJsKNW4R1e2QY4wVubfpC3s2LVkE4Amow@mail.gmail.com>
References: <1402602419-27934-1-git-send-email-keescook@chromium.org> <1737131.VlQuirUC3S@vostro.rjw.lan> <CAGXu5j+BTYup-9cbwSJsKNW4R1e2QY4wVubfpC3s2LVkE4Amow@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 13, 2014 03:59:57 PM Kees Cook wrote:
> On Fri, Jun 13, 2014 at 3:54 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Friday, June 13, 2014 03:07:19 PM Kees Cook wrote:

[cut]

> > I'll have a closer look at that shortly (it's been quite some time since
> > I wrote that code).
> 
> Thanks; I'm trying to get a test environment instrumented too so I can
> look at this. (At the very least, it sounds like we'll still need my
> patch series for other architectures.)

How can I obtain a kernel address of the beginning of a given page
(as represented by struct page) on x86_64 today?

Rafael

