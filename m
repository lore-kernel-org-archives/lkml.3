Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3LJQIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:08:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56338 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab3LJQIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:08:34 -0500
Date: Tue, 10 Dec 2013 17:08:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Petr Mladek <pmladek@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v6 2/8] x86: allow to call text_poke_bp during boot
Message-ID: <20131210160827.GF31437@pd.tnic>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
 <1386690140-19941-3-git-send-email-pmladek@suse.cz>
 <20131210154612.GA31490@pd.tnic>
 <20131210110157.5eb1498e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131210110157.5eb1498e@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 11:01:57AM -0500, Steven Rostedt wrote:
> That can be changed in a later patch if needed. It's a static function
> so the visibility is limited. Not to mention, it was just moved from
> ftrace.c which calls it run_sync().

Moved?

The diffstat has only

 arch/x86/kernel/alternative.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

or is the move in yet another patch?

> We need to keep the same name for the move to not confuse the history
> of where it came from.

Whatever makes you ftrace dudes happy. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
