Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaLSHkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 02:40:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaLSHj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 02:39:59 -0500
Date: Fri, 19 Dec 2014 08:39:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 2/3] kernel: add support for live patching
In-Reply-To: <1418752700-14649-3-git-send-email-sjenning@redhat.com>
Message-ID: <alpine.LNX.2.00.1412190837540.1680@pobox.suse.cz>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com> <1418752700-14649-3-git-send-email-sjenning@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Seth Jennings wrote:

> This commit introduces code for the live patching core.  It implements
> an ftrace-based mechanism and kernel interface for doing live patching
> of kernel and kernel module functions.
> 
> It represents the greatest common functionality set between kpatch and
> kgraft and can accept patches built using either method.
> 
> This first version does not implement any consistency mechanism that
> ensures that old and new code do not run together.  In practice, ~90% of
> CVEs are safe to apply in this way, since they simply add a conditional
> check.  However, any function change that can not execute safely with
> the old version of the function can _not_ be safely applied in this
> version.
> 
> Signed-off-by: Seth Jennings <sjenning@redhat.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>

I have finally finished reviewing this as well.

Reviewed-by: Jiri Kosina <jkosina@suse.cz>

and

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

for the changes I contributed.

I'll wait a bit more to eventually gather more acks / review comments, and 
will then push it to git.kernel.org repository (with SUSE copyright added 
to livepatch.c) and have included in linux-next, as discussed before.

Thanks!

-- 
Jiri Kosina
SUSE Labs
