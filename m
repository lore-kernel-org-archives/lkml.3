Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaKZJ0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:26:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbaKZJ0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:26:02 -0500
Date: Wed, 26 Nov 2014 10:26:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/3] Kernel Live Patching
In-Reply-To: <alpine.LNX.2.00.1411261014510.23174@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1411261025430.23174@pobox.suse.cz>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com> <547596C6.2050303@hitachi.com> <alpine.LNX.2.00.1411261014510.23174@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014, Jiri Kosina wrote:

> What I'd propose instead is to make sure that we always have 
> just a ftrace_ops per function entry, and only update the pointers there 

"... just a _single_ ..."

-- 
Jiri Kosina
SUSE Labs
