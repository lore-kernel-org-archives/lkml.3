Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaDCOum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:50:42 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37525 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaDCOuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:50:40 -0400
Date: Thu, 3 Apr 2014 15:50:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140403145022.GA31056@srcf.ucam.org>
References: <20140403021411.6236996f@gandalf.local.home>
 <070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>
 <533D001A.5030802@linux.intel.com>
 <20140403094155.04cc00bc@gandalf.local.home>
 <533D6BE7.3020608@zytor.com>
 <20140403104721.5f6c32b6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403104721.5f6c32b6@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 10:47:21AM -0400, Steven Rostedt wrote:
> > reboot=a
> 
> Passed

Huh. We should be trying the acpi method twice before we try PCI at all, 
unless something's gone very wrong.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
