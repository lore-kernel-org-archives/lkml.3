Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbaDGPmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:42:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:25852 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753057AbaDGPmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:42:36 -0400
Date: Mon, 7 Apr 2014 11:42:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mjg59@srcf.ucam.org, aubrey.li@linux.intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
Message-ID: <20140407114231.7dd12a07@gandalf.local.home>
In-Reply-To: <20140404080006.GB6944@gmail.com>
References: <20140404064120.GB11877@gmail.com>
	<tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>
	<20140404080006.GB6944@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2014 10:00:07 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * tip-bot for Ingo Molnar <tipbot@zytor.com> wrote:
> 
> > Commit-ID:  d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3
> > Gitweb:     http://git.kernel.org/tip/d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3
> > Author:     Ingo Molnar <mingo@kernel.org>
> > AuthorDate: Fri, 4 Apr 2014 08:41:26 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Fri, 4 Apr 2014 08:48:03 +0200
> > 
> > [PATCH] x86: Try the BIOS reboot method before the PCI reboot method
> 
> So, JFYI, I have put this into x86/reboot to get it tested, but it's 
> not queued up for upstream yet until there's concensus.
> 
> (Steve testing it wouldn't hurt either.)

Tested, and with this patch it reboots fine.

I booted without the patch, and it failed to reboot.

I added the patch, booted it, checked if I had the right kernel with
uname, and then rebooted. It rebooted fine.

Went back, removed the patch, rebuilt and rebooted. Tried to reboot,
and it failed again.

Tested-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
