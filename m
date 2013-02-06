Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab3BFUp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:45:57 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:59454 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169Ab3BFUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:45:54 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
References: <1356040315.3198.51.camel@shinybook.infradead.org>
	<tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org>
	<alpine.DEB.2.00.1212252222450.24528@chino.kir.corp.google.com>
	<1356564746.7010.56.camel@shinybook.infradead.org>
	<50DB9FA5.6070704@infradead.org>
	<alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
	<20130204184436.GA13256@gmail.com>
	<alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
	<20130204191408.GA32081@kroah.com>
	<20130204191334.GB14837@gmail.com>
	<CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
	<alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
Date: Wed, 6 Feb 2013 22:45:53 +0200
X-Google-Sender-Auth: lhAWF_bgkpvgt2-7b-cnKx4VN7k
Message-ID: <CAOJsxLEadL8USuW5zEuaW-OexEbgZvqdj5U6u5gEgOyQ5LCLRA@mail.gmail.com>
Subject: Re: [patch] config: fix make kvmconfig
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 10:12 PM, David Rientjes <rientjes@google.com> wrote:
> What's the endgame for kvmtool/next?  The patch that this fixes has been
> sitting in linux-next for over 15 months and hasn't been pulled by Linus,
> yet some find it to be quite useful.
>
> Is it a permanent addition to linux-next, is there a route to mainline,
> or something else?

It is actively developed and has recently gained support for ARM, for
example. Ingo keeps pulling it to the -tip tree so tools/kvm also
appears on linux-next through that. Linus doesn't think it's worth
pulling and the KVM maintainers are uninterested.

So I guess we've deadlocked the Linux kernel development process?
