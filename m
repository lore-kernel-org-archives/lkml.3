Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaDCPft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:35:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:12213 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752411AbaDCPfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:35:48 -0400
Date: Thu, 3 Apr 2014 11:35:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140403113545.73261dfe@gandalf.local.home>
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


Rechecked my answers.

On Thu, 3 Apr 2014 10:47:21 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 03 Apr 2014 07:10:47 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > Could you tell which of these modes work on your box:
> > 
> > reboot=t
> 
> I already stated that 't' works.

Yes it works.

> 
> > reboot=k
> 
> Fails

Still fails.

> 
> > reboot=b	(BIOS only)
> 
> Passed

Still passes.

> 
> > reboot=a
> 
> Passed

Correction, this consistently fails.

> 
> > reboot=e	(EFI only)
> 
> Fails

Still fails.

> 
> > reboot=p
> 
> Fails

Still fails.

-- Steve
