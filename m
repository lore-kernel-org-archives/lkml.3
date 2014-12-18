Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaLRNg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 08:36:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaLRNg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 08:36:58 -0500
Date: Thu, 18 Dec 2014 14:36:51 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 2/3] kernel: add support for live patching
Message-ID: <20141218133651.GC9885@dhcp128.suse.cz>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
 <1418752700-14649-3-git-send-email-sjenning@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418752700-14649-3-git-send-email-sjenning@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-12-16 11:58:19, Seth Jennings wrote:
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

I like the current state. Thanks a lot for the effort.

Reviewed-by: Petr Mladek <pmladek@suse.cz>

and for my changes:

Signed-off-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
