Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3LJQoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:44:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab3LJQoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:44:38 -0500
Subject: Re: [PATCH v6 2/8] x86: allow to call text_poke_bp during boot
From: Petr Mladek <pmladek@suse.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
In-Reply-To: <20131210160827.GF31437@pd.tnic>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	 <1386690140-19941-3-git-send-email-pmladek@suse.cz>
	 <20131210154612.GA31490@pd.tnic>
	 <20131210110157.5eb1498e@gandalf.local.home>
	 <20131210160827.GF31437@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Dec 2013 17:44:36 +0100
Message-ID: <1386693876.29735.40.camel@pathway.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov píše v Út 10. 12. 2013 v 17:08 +0100:
> On Tue, Dec 10, 2013 at 11:01:57AM -0500, Steven Rostedt wrote:
> > That can be changed in a later patch if needed. It's a static function
> > so the visibility is limited. Not to mention, it was just moved from
> > ftrace.c which calls it run_sync().
> 
> Moved?
> 
> The diffstat has only
> 
>  arch/x86/kernel/alternative.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> or is the move in yet another patch?

Yes, it is removed from arch/x86/kernel/ftrace.c in the 7th patch of
this patch set.

Best Regards,
Petr

