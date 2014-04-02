Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030289AbaDBUn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:43:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:55205 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030269AbaDBUnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:43:24 -0400
Date: Wed, 2 Apr 2014 22:43:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Weinberger <richard.weinberger@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
In-Reply-To: <CAFLxGvyBgKQLvSUcbn3EqcEomUgY85PXJBM7JoMKiyizt66gYA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1404022231390.14882@ionos.tec.linutronix.de>
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402120440.1644d6a6486c554a33e584bc@linux-foundation.org> <alpine.DEB.2.02.1404022146530.14882@ionos.tec.linutronix.de> <CAFLxGvyBgKQLvSUcbn3EqcEomUgY85PXJBM7JoMKiyizt66gYA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2014, Richard Weinberger wrote:
> While we are here, can we please also talk about the !cgroup situation?
> https://bugs.freedesktop.org/show_bug.cgi?id=74589
> 
> A segfaulting systemd on CONFIG_CGROUPS=n is no fun.

Wow, the attitude there is amazing:

"To make this work we'd need a patch, as nobody of us tests this."

Rule #1: systemd maintainers worldview is always correct

Rule #2: In the unexpected case that you think the worldview of
     	 systemd maintainers is incorrect, apply rule #1.

Thanks,

	tglx
