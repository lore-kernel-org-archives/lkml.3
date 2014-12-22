Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaLVTpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:45:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbaLVTpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:45:03 -0500
Date: Mon, 22 Dec 2014 20:44:59 +0100 (CET)
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
Subject: Re: [PATCHv7 0/3] Kernel Live Patching
In-Reply-To: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
Message-ID: <alpine.LNX.2.00.1412221342540.1680@pobox.suse.cz>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Seth Jennings wrote:

> I think that we have something that is workable for everyone now.  
> Barring functional defects, I think we should put a hold on any nits to 
> avoid churn for the moment and start gathering acks so that we are in a 
> position to go into -next when the 3.19 window closes.

I have now established GIT tree on kernel.org [1] that has all the patches 
applied with all acks and reviewed-by gathered so far, and will be asking 
Stephen to start pulling 'for-next' branch into linux-next.

(I've fixed the FTRACE_FL_IPMODIFY -> FTRACE_OPS_FL_IPMODIFY issue while 
doing so, so no need to resend just because of that, Josh).

[1] git://git.kernel.org/pub/scm/linux/kernel/git/jikos/livepatching.git
    https://git.kernel.org/cgit/linux/kernel/git/jikos/livepatching.git/

-- 
Jiri Kosina
SUSE Labs
