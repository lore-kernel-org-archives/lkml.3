Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaDDSBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:01:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56107 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbaDDSBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:01:05 -0400
Date: Fri, 4 Apr 2014 19:00:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140404180054.GA25997@srcf.ucam.org>
References: <20140403194018.7c67aec7@gandalf.local.home>
 <533DF455.4040908@linux.intel.com>
 <533DF8D2.9060508@zytor.com>
 <533E0A94.5040007@linux.intel.com>
 <20140404151203.GA12370@srcf.ucam.org>
 <533ECC2C.6090505@zytor.com>
 <20140404153634.GA14519@srcf.ucam.org>
 <20140404173431.GA25173@gmail.com>
 <bca5033b-bd33-4e5e-8893-3c9dcf76be7d@email.android.com>
 <20140404174437.GC25173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140404174437.GC25173@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 07:44:37PM +0200, Ingo Molnar wrote:
> 
> Before any other change is done beyond the revert of this latest 
> broken commit.

The commit in question was the one that added the misleading text to the 
comment. I'm sorry, I should have caught that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
