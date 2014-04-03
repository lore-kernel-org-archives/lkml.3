Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaDCNpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:45:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36636 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaDCNpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:45:41 -0400
Date: Thu, 3 Apr 2014 14:45:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140403134526.GA25186@srcf.ucam.org>
References: <20140403021411.6236996f@gandalf.local.home>
 <070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>
 <533D001A.5030802@linux.intel.com>
 <20140403094155.04cc00bc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403094155.04cc00bc@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 09:41:55AM -0400, Steven Rostedt wrote:
> On Thu, 03 Apr 2014 14:30:50 +0800
> "Li, Aubrey" <aubrey.li@linux.intel.com> wrote:
> 
> 
> > May I know if "reboot=t" make any difference on your system with the change?
> 
> Is this the future fix? Or do you have patches for me to test. I'll be
> happy to test any patches you have on this box. If you need to know
> anything about this box, let me know and I'll run any command that
> would help you.

I think what this tells us is we should revert the patch and never try 
0xcf9 by default.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
