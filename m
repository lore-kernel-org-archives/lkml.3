Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab3B1GrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:47:09 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:42203 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3B1GrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:47:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130227135155.c04453db.akpm@linux-foundation.org>
References: <1361944667.957820@landley.net>
	<20130227135155.c04453db.akpm@linux-foundation.org>
Date: Thu, 28 Feb 2013 07:47:05 +0100
X-Google-Sender-Auth: uCIK3cEwVFDcRMeD5FJbYDq7Yj4
Message-ID: <CAMuHMdWpZ3_3x-Swfm6E_2bD7LQ-Hs3XCfy24hJLJuSCE+M+CQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] build linux-next without perl
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Dave Jones <davej@redhat.com>,
        David Howells <dhowell@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>, Michal Marek <mmarek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, x86@kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 10:51 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> It'll need to be reasonably good motivation, too.  Because not only do
> we need to patch the kernel, we also need to *maintain* its
> perl-freeness and fix up perlisms as they later get added by others.

That's actually a backwards argument: as long as there are scripts in the kernel
source tree using perl, people will add more of them, since they see perl is an
accepted scripting language within the Linux kernel build system.

It's the same as refactoring existing code: if we don't, people will
copy the bad
examples. So we fix them, to avoid this.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
