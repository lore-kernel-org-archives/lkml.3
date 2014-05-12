Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbaELRJC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:09:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbaELRJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:09:00 -0400
Date: Mon, 12 May 2014 19:08:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>
Subject: [PATCH 0/1] (Was: cleanup DO_ERROR*() to prepare for uprobes fixes)
Message-ID: <20140512170822.GA28335@redhat.com>
References: <20140508191140.GA16892@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508191140.GA16892@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Oleg Nesterov wrote:
>
> But let me send the initial changes first for review. If they pass the review
> and if nobody objects, I'd like to route them along with the pending uprobes
> fixes.

OK, nobody cares ;)

So I am going to ask Ingo to pull these changes plus the following minor fix.

To remind, I think that traps.c needs more cleanups: do_general_protection()
and math_error() should be converted into DO_ERROR(), DIE_GPF should die, and
the users of show_unhandled_signals() should be unified/cleanuped.

Ananth, David, this is x86 specific, but at first glance powerpc/arm might
want to use uprobe_get_trap_addr() too.

Oleg.

