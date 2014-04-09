Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400AbaDIUus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:50:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50194 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933590AbaDIUur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:50:47 -0400
Message-ID: <5345B278.8060703@zytor.com>
Date: Wed, 09 Apr 2014 13:50:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Adam Williamson <awilliam@redhat.com>
CC: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        rostedt@goodmis.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
References: <20140404064120.GB11877@gmail.com>			<tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>			<20140404080006.GB6944@gmail.com>	<533EB5F1.8060002@linux.intel.com>			<20140404151359.GB12370@srcf.ucam.org>		 <20140406184023.1e31412d@alan.etchedpixels.co.uk>		 <53419F84.2090204@zytor.com> <53425B2A.10001@linux.intel.com>		 <53431296.10502@zytor.com>	 <1396908292.4958.24.camel@adam.happyassassin.net>	 <5343220A.3060007@zytor.com> <1396912372.4958.41.camel@adam.happyassassin.net>
In-Reply-To: <1396912372.4958.41.camel@adam.happyassassin.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 04:12 PM, Adam Williamson wrote:
> 
> basically, we know that we probably can't come up with a standard
> fallback chain that will work for *every* system, and the goal instead
> is to come up with the approach that requires the *fewest* quirks.
> 

Not quite.

The problem is that we can't test everything, so part of it isn't just
about the amount of quirks but also our confidence level in them.

	-hpa

