Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaDDPOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:14:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53739 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaDDPOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:14:05 -0400
Date: Fri, 4 Apr 2014 16:13:59 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        rostedt@goodmis.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method
 before the PCI reboot method
Message-ID: <20140404151359.GB12370@srcf.ucam.org>
References: <20140404064120.GB11877@gmail.com>
 <tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>
 <20140404080006.GB6944@gmail.com>
 <533EB5F1.8060002@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533EB5F1.8060002@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 09:38:57PM +0800, Li, Aubrey wrote:

> I don't think there is enough justification to revert the patch. We
> introduce EFI into the default list, we didn't see any reason to remove
> it out so far.

We should be using the EFI method, yes. But it seems that CF9 isn't 
safe, so we should drop that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
