Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaKYT0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:26:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaKYT0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:26:15 -0500
Date: Tue, 25 Nov 2014 20:26:22 +0100 (CET)
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
Subject: Re: [PATCHv4 0/3] Kernel Live Patching
In-Reply-To: <1416935709-404-1-git-send-email-sjenning@redhat.com>
Message-ID: <alpine.LNX.2.00.1411252017010.23174@pobox.suse.cz>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014, Seth Jennings wrote:

> Masami's IPMODIFY patch is heading for -next via your tree.  Once it arrives,
> I'll rebase and make the change to set IPMODIFY.  Do not pull this for -next
> yet.  This version (v4) is for review and gathering acks.

Thanks for sending out v4 and incorporating the feedback, I really 
appreciate your responsiveness!

Anyway, I don't think targetting 3.19 is realistic, given we're currently 
already past 3.18-rc6 ... even if we rush it into -next in the coming 
days, it will get close to zero exposure in there before the merge window 
opens.

I'd like to do quite some more testing and still finish some pending 
portions of code reviews on our side (especially to make sure that this 
can be easily extended to support any consistency model in the future).

Once we start collecting Reviewed-by's / Acked-by's on this patchset, I 
can establish a tree on git.kernel.org that we can use to collect any 
followup patches during 3.20 development cycle and send a pull request to 
Linus during 3.20 merge window .. if everybody agrees with this course of 
action, obviously.

Thanks,

-- 
Jiri Kosina
SUSE Labs
