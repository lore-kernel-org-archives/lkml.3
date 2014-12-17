Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaLQOGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:06:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaLQOGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:06:23 -0500
Date: Wed, 17 Dec 2014 15:06:18 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 1/3] kernel: add TAINT_LIVEPATCH
In-Reply-To: <1418752700-14649-2-git-send-email-sjenning@redhat.com>
Message-ID: <alpine.LNX.2.00.1412171505400.24184@pobox.suse.cz>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com> <1418752700-14649-2-git-send-email-sjenning@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Seth Jennings wrote:

> This adds a new taint flag to indicate when the kernel or a kernel
> module has been live patched.  This will provide a clean indication in
> bug reports that live patching was used.
> 
> Additionally, if the crash occurs in a live patched function, the live
> patch module will appear beside the patched function in the backtrace.
> 
> Signed-off-by: Seth Jennings <sjenning@redhat.com>

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

Thanks,
--
Miroslav Benes
SUSE Labs
