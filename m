Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab3G0QTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 12:19:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45376 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab3G0QTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 12:19:44 -0400
Date: Sat, 27 Jul 2013 18:19:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizefan@huawei.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] tracing: Shrink the size of struct
 ftrace_event_field
Message-ID: <20130727161937.GD6314@pd.tnic>
References: <51F08D1B.1080300@huawei.com>
 <51F08D4B.3010201@huawei.com>
 <1374851376.6580.34.camel@gandalf.local.home>
 <51F33F41.9040902@huawei.com>
 <1374896842.6580.44.camel@gandalf.local.home>
 <20130727084528.GA6923@pd.tnic>
 <1374924938.6580.46.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1374924938.6580.46.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 07:35:38AM -0400, Steven Rostedt wrote:
> But you know me. I LOVE macros!

I'll say.

Btw, I wouldn't wonder if you start sending patches for the gcc C
preprocessor because it evaluates your macro voodoo too slow.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
