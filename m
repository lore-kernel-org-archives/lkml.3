Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934784Ab3GRWY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:24:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932931Ab3GRWY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:24:57 -0400
Date: Fri, 19 Jul 2013 00:24:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        yrl.pp-manager.tt@hitachi.com, Borislav Petkov <bpetkov@suse.de>
Subject: Re: [PATCH -tip  0/3] kprobes, x86: Move optprobe on top of int3-based
 instruction patching
In-Reply-To: <20130718114738.26675.85914.stgit@mhiramat-M0-7522>
Message-ID: <alpine.LNX.2.00.1307190024110.31632@pobox.suse.cz>
References: <20130718114738.26675.85914.stgit@mhiramat-M0-7522>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jul 2013, Masami Hiramatsu wrote:

> Hi,
> 
> Here is a series of kprobes and x86 patches for moving
> optprobe (jump optimized kprobe) onto the int3-based
> instruction patching (a.k.a. text_poke_bp, introduced by
> Jiri Kosina).
> 
> Since this completely moves text_poke_smp* user to new
> text_poke_bp, I also remove the old text_poke_smp* code
> from alternative.c. As a side effect, it also fixes a
> Kconfig warning about CONFIG_STOP_MACHINE dependency
> confliction.
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (3):
>       [CLEANUP] kprobes/x86: Remove an incorrect comment about int3 in NMI/MCE
>       kprobes/x86: Use text_poke_bp() instead of text_poke_smp*()
>       x86: Remove unused text_poke_smp and text_poke_smp_batch

Nice.

	Reviewed-by: Jiri Kosina <jkosina@suse.cz>

Thanks.

-- 
Jiri Kosina
SUSE Labs
