Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaDDP32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:29:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49676 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbaDDP30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:29:26 -0400
Message-ID: <533ECFB0.9060903@zytor.com>
Date: Fri, 04 Apr 2014 08:28:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Li, Aubrey" <aubrey.li@linux.intel.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rostedt@goodmis.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
References: <20140404064120.GB11877@gmail.com> <tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org> <20140404080006.GB6944@gmail.com> <533EB5F1.8060002@linux.intel.com> <20140404151359.GB12370@srcf.ucam.org>
In-Reply-To: <20140404151359.GB12370@srcf.ucam.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 08:13 AM, Matthew Garrett wrote:
> On Fri, Apr 04, 2014 at 09:38:57PM +0800, Li, Aubrey wrote:
> 
>> I don't think there is enough justification to revert the patch. We
>> introduce EFI into the default list, we didn't see any reason to remove
>> it out so far.
> 
> We should be using the EFI method, yes. But it seems that CF9 isn't 
> safe, so we should drop that.
> 

As I said, I'm willing to hear about production hardware having problems
before killing it off, but we should dig into the history of the past
removal.

	-hpa

