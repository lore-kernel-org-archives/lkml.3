Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbbA0GTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 01:19:51 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:53437 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbbA0GTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 01:19:49 -0500
Date: Tue, 27 Jan 2015 07:19:42 +0100
From: Dominik Vogt <vogt@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Masami Hiramatsu <maasami.hiramatsu.pt@hitachi.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/3] ftrace: introduce nohotpatch function attribute
Message-ID: <20150127061941.GA4591@linux.vnet.ibm.com>
Reply-To: vogt@linux.vnet.ibm.com
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Masami Hiramatsu <maasami.hiramatsu.pt@hitachi.com>,
	Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
	Jiri Slaby <jslaby@suse.cz>,
	Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org
References: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
 <1422276894-31302-3-git-send-email-heiko.carstens@de.ibm.com>
 <20150126093701.699763dc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126093701.699763dc@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012706-0009-0000-0000-000002E99342
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 09:37:01AM -0500, Steven Rostedt wrote:
> On Mon, 26 Jan 2015 13:54:53 +0100
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > s390 will use the hotpatch attribute for function tracing, therefore
> > introduce a nohotpatch define, depending on CC_USING_HOTPATCH, and add it
> > to the existing notrace define.
> 
> Are the two mutually exclusive? That is, can you have -pg and hotpatch
> together? Reason why I ask is, if you have either -pg or hotpatch, then
> we only need "no_instrument_function" or "hotpatch" in the notrace
> define, not both. But I could be wrong.

While the kernel may use only profiling or hotpatch at the same
time, Gcc is able to generate both for the same function.

Ciao

Dominik ^_^  ^_^

-- 

Dominik Vogt
IBM Germany

