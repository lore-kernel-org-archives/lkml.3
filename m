Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaDDPM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:12:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53693 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbaDDPMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:12:25 -0400
Date: Fri, 4 Apr 2014 16:12:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140404151203.GA12370@srcf.ucam.org>
References: <533D7C4F.4010504@zytor.com>
 <533D7C93.7080105@zytor.com>
 <20140403113921.23dceb75@gandalf.local.home>
 <533D8516.1040803@zytor.com>
 <20140403121314.246b03a7@gandalf.local.home>
 <533DED74.6050202@linux.intel.com>
 <20140403194018.7c67aec7@gandalf.local.home>
 <533DF455.4040908@linux.intel.com>
 <533DF8D2.9060508@zytor.com>
 <533E0A94.5040007@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533E0A94.5040007@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 09:27:48AM +0800, Li, Aubrey wrote:

> The current situation is,
> - we have one(do we know more?) preproduction machine hangs by CF9.
> - We have more than one(could be thousand known) production machine
> works by CF9.

Production hardware should never require CF9.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
