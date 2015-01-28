Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbbA1Fgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:36:53 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:54327 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbbA1Fgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 00:36:52 -0500
Date: Wed, 28 Jan 2015 06:36:45 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dominik Vogt <vogt@linux.vnet.ibm.com>,
        Masami Hiramatsu <maasami.hiramatsu.pt@hitachi.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/3] ftrace: introduce nohotpatch function attribute
Message-ID: <20150128053645.GA4633@osiris>
References: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
 <1422276894-31302-3-git-send-email-heiko.carstens@de.ibm.com>
 <20150126093701.699763dc@gandalf.local.home>
 <20150127061941.GA4591@linux.vnet.ibm.com>
 <20150127094228.50e642fc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127094228.50e642fc@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012805-0021-0000-0000-000002B35F47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 09:42:28AM -0500, Steven Rostedt wrote:
> On Tue, 27 Jan 2015 07:19:42 +0100
> Dominik Vogt <vogt@linux.vnet.ibm.com> wrote:
>  
> > While the kernel may use only profiling or hotpatch at the same
> > time, Gcc is able to generate both for the same function.
> 
> Understood, but would that be useful for the kernel?

Right now not. We may change that anyway in the future if needed.

Steven, how do we proceed with this small series?

Since there don't seem to be any objections, I'll repost with the
changed notrace define. However I think the whole stuff should go
upstream via the ftrace tree. Is that ok with you?

FWIW, the s390 gcc hotpatch feature was merged in the meantime:
https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=11762b8363737591bfb9c66093bc2edf289b917f

