Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3CLMJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:09:36 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:44478 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3CLMJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:09:35 -0400
Date: Tue, 12 Mar 2013 13:09:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Move hash_64() into .text.kprobe
 section
Message-ID: <20130312120930.GA20711@gmail.com>
References: <20130311142233.19885.10567.stgit@mhiramat-M0-7522>
 <20130312082112.GB30665@gmail.com>
 <513F0C74.4030101@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513F0C74.4030101@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> > The only complication is that __kprobes is now present in 600+ places, 
> > which will create merge conflicts. If you remind me during the next 
> > merge window I can generate the rename on the spot and send it to 
> > Linus without anyone having to carry the patch for too long.
> 
> Let me confirm that I just move __kprobes definition into compiler.h 
> this time, and ping you when the next merge window opens, is that 
> correct?

Yeah, two stages - that would be cool.

Thanks,

	Ingo
