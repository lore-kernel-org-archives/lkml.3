Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbbAZP0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:26:09 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:38135 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbbAZP0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:26:07 -0500
Date: Mon, 26 Jan 2015 16:26:00 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <maasami.hiramatsu.pt@hitachi.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        Dominik Vogt <vogt@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/3] ftrace: introduce nohotpatch function attribute
Message-ID: <20150126152600.GA6977@osiris>
References: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
 <1422276894-31302-3-git-send-email-heiko.carstens@de.ibm.com>
 <20150126093701.699763dc@gandalf.local.home>
 <20150126150319.GF4968@osiris>
 <20150126102226.6f76b2ab@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126102226.6f76b2ab@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012615-0041-0000-0000-0000030EE8C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 10:22:26AM -0500, Steven Rostedt wrote:
> On Mon, 26 Jan 2015 16:03:19 +0100
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > Actually they should be mutually exclusive. I just merged them "just in case".
> > 
> > So something like this
> > 
> > #ifdef CC_USING_HOTPATCH
> > #define notrace __attribute__((hotpatch(0,0)))
> > #else
> > #define notrace __attribute__((no_instrument_function))
> > #endif
> > 
> > will work as well (just tested).
> 
> I think the above change looks cleaner.

Yes, I agree with you and will change the patch.

