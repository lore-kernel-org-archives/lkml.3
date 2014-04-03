Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaDCPO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:14:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:8831 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752258AbaDCPOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:14:53 -0400
Date: Thu, 3 Apr 2014 11:14:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140403111451.14a53fb8@gandalf.local.home>
In-Reply-To: <20140403145022.GA31056@srcf.ucam.org>
References: <20140403021411.6236996f@gandalf.local.home>
	<070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>
	<533D001A.5030802@linux.intel.com>
	<20140403094155.04cc00bc@gandalf.local.home>
	<533D6BE7.3020608@zytor.com>
	<20140403104721.5f6c32b6@gandalf.local.home>
	<20140403145022.GA31056@srcf.ucam.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2014 15:50:22 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Apr 03, 2014 at 10:47:21AM -0400, Steven Rostedt wrote:
> > > reboot=a
> > 
> > Passed
> 
> Huh. We should be trying the acpi method twice before we try PCI at all, 
> unless something's gone very wrong.
> 

Bah, after getting this email, I tried again, and it fails on 'a'.

I may have booted into the wrong kernel, or miscounted my reboots.

Put this down as a FAIL :-(


-- Steve
