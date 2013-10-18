Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3JROix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:38:53 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:43226 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3JROiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:38:52 -0400
Date: Fri, 18 Oct 2013 16:38:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 0/6] x86: use new text_poke_bp in ftrace
Message-ID: <20131018143845.GA7144@localhost.localdomain>
References: <1382106445-31468-1-git-send-email-pmladek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382106445-31468-1-git-send-email-pmladek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 04:27:19PM +0200, Petr Mladek wrote:
[...]
> 
>  arch/x86/include/asm/alternative.h |   3 +-
>  arch/x86/kernel/alternative.c      | 135 ++++++--
>  arch/x86/kernel/ftrace.c           | 605 ++++++++---------------------------
>  arch/x86/kernel/jump_label.c       |   3 +-
>  arch/x86/kernel/kprobes/opt.c      |   8 +-
>  arch/x86/kernel/traps.c            |  10 -
>  lib/bsearch.c                      |   2 +-
>  7 files changed, 264 insertions(+), 502 deletions(-)

Nice!
