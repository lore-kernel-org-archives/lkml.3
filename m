Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaDDPqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:46:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54404 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbaDDPqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:46:10 -0400
Date: Fri, 4 Apr 2014 16:46:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140404154600.GB14980@srcf.ucam.org>
References: <20140403121314.246b03a7@gandalf.local.home>
 <533DED74.6050202@linux.intel.com>
 <20140403194018.7c67aec7@gandalf.local.home>
 <533DF455.4040908@linux.intel.com>
 <533DF8D2.9060508@zytor.com>
 <533E0A94.5040007@linux.intel.com>
 <20140404151203.GA12370@srcf.ucam.org>
 <533ECC2C.6090505@zytor.com>
 <20140404153634.GA14519@srcf.ucam.org>
 <533ED247.9040602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533ED247.9040602@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 08:39:51AM -0700, H. Peter Anvin wrote:
> 
> There are several platforms where the default boot method invokes an SMM
> handler which blithly assumes that the hardware is in whatever state
> Windows leaves it in, and hangs otherwise.  This seems to include nearly
> all Dell systems.  So it isn't really quite that simple...

That's the story of all firmware, ever.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
