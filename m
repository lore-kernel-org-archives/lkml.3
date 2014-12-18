Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaLRPwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:52:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaLRPwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:52:07 -0500
Date: Thu, 18 Dec 2014 16:52:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 1/3] kernel: add TAINT_LIVEPATCH
In-Reply-To: <5492BE01.7040705@hitachi.com>
Message-ID: <alpine.LNX.2.00.1412181651260.1680@pobox.suse.cz>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com> <1418752700-14649-2-git-send-email-sjenning@redhat.com> <5492BE01.7040705@hitachi.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014, Masami Hiramatsu wrote:

> > This adds a new taint flag to indicate when the kernel or a kernel
> > module has been live patched.  This will provide a clean indication in
> > bug reports that live patching was used.
> > 
> > Additionally, if the crash occurs in a live patched function, the live
> > patch module will appear beside the patched function in the backtrace.
> > 
> > Signed-off-by: Seth Jennings <sjenning@redhat.com>
> 
> Looks good to me.
> 
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Masami, just for completness -- is this just for 1/3, or for the whole 
series? (so that I get it right once I am applying the patches to git 
tree).

Thanks,

-- 
Jiri Kosina
SUSE Labs
