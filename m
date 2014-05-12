Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaELHjC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:39:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbaELHjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:39:00 -0400
Date: Mon, 12 May 2014 09:38:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [RFC PATCH] ftrace/x86: Move the mcount/fentry code out of
 entry_64.S
In-Reply-To: <20140508152152.2130e8cf@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1405120938170.5813@pobox.suse.cz>
References: <20140508152152.2130e8cf@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Steven Rostedt wrote:

> As the mcount code gets more complex, it really does not belong
> in the entry.S file. By moving it into its own file "mcount.S"
> keeps things a bit cleaner.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

I am obviously very happy about where this is heading :) hence FWIW

	Acked-by: Jiri Kosina <jkosina@suse.cz>

Thanks,

-- 
Jiri Kosina
SUSE Labs
