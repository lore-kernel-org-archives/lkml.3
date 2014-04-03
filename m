Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaDCPRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:17:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:4475 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752265AbaDCPRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:17:12 -0400
Date: Thu, 3 Apr 2014 11:17:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140403111711.5bed4ff7@gandalf.local.home>
In-Reply-To: <20140403104721.5f6c32b6@gandalf.local.home>
References: <20140403021411.6236996f@gandalf.local.home>
	<070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>
	<533D001A.5030802@linux.intel.com>
	<20140403094155.04cc00bc@gandalf.local.home>
	<533D6BE7.3020608@zytor.com>
	<20140403104721.5f6c32b6@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2014 10:47:21 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 03 Apr 2014 07:10:47 -0700

> Passed
> 
> > reboot=a

After getting Matthew's email, I tried this again and it failed to
boot. Let me rerun through the list again and I'll report back if
things have changed.

Changing options, rebooting, changing options rebooting, gets a bit
confusing. I may have rebooted the 'b' and thought it was the 'a'.

-- Steve
