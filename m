Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979AbaFQUtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:49:51 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52296 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964783AbaFQUtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:49:49 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Len Brown <len.brown@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 0/2] make kASLR vs hibernation boot-time selectable
Date: Tue, 17 Jun 2014 23:07:23 +0200
Message-ID: <4620697.7oeP2zTOEF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGXu5jKpSqu6-AeHoiEhBzEYSujthT_UeHNSUKQ6TXhg-S=SPg@mail.gmail.com>
References: <1402691436-20138-1-git-send-email-keescook@chromium.org> <2113876.sBNaASbVKF@vostro.rjw.lan> <CAGXu5jKpSqu6-AeHoiEhBzEYSujthT_UeHNSUKQ6TXhg-S=SPg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 13, 2014 11:09:15 PM Kees Cook wrote:
> On Fri, Jun 13, 2014 at 4:25 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Friday, June 13, 2014 01:30:34 PM Kees Cook wrote:
> >> Distros want to be able to offer CONFIG_RANDOMIZE_BASE as well as
> >> CONFIG_HIBERNATION in a single kernel. Instead of making kASLR depend on
> >> !HIBERNATION at compile time, allow kaslr to be selectable at boot time
> >> (via "kaslr" kernel command line), which will disable hibernation in the
> >> kernel. In this way the end user can choose which feature they want more
> >> with hibernation continuing to stay enabled by default (no surprises).
> >>
> >> This also has the benefit of being able to entirely disable hibernation
> >> from the kernel command line, regardless of kASLR, which is a separately
> >> desired feature as well.
> >>
> >> v3:
> >> - switch from EINVAL to EPERM (pavel, jwboyer)
> >> v2:
> >> - rework using kernel command line instead of hibernation_mode (rjw)
> >
> > That looks kind of OK.
> >
> > Do you want me to push this through my tree?
> 
> Thanks, yes, that would be great.

OK, both applied, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
