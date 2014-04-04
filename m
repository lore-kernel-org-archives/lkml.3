Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaDDRst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:48:49 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:64063 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaDDRsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:48:46 -0400
Date: Fri, 4 Apr 2014 19:48:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mjg59@srcf.ucam.org, rostedt@goodmis.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
Message-ID: <20140404174842.GA25736@gmail.com>
References: <20140404064120.GB11877@gmail.com>
 <tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>
 <20140404080006.GB6944@gmail.com>
 <533EB5F1.8060002@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533EB5F1.8060002@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li, Aubrey <aubrey.li@linux.intel.com> wrote:

> <cc to adam>
> 
> On 2014/4/4 16:00, Ingo Molnar wrote:
> > 
> >>
> >> [PATCH] x86: Try the BIOS reboot method before the PCI reboot method
> > 
> > So, JFYI, I have put this into x86/reboot to get it tested, but it's 
> > not queued up for upstream yet until there's concensus.
> > 
> > (Steve testing it wouldn't hurt either.)
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> The change is originated from the following bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=70931
> 
> The system will hang after BIOS or TRIPLE if it doesn't work, that's 
> why I added CF9 before BIOS and TRIPLE.
> 
> Adam may want to try this change to see if reboot works on his DELL 
> Venue 8 Pro.
> 
> I don't think there is enough justification to revert the patch. 
> [...]

'Breaks a box' is more than enough justification to revert a patch...

You can try to fix boxes, but only if you can do it without breaking 
others.

Thanks,

	Ingo
