Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbaBFW6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:58:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:18003 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214AbaBFW6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:58:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,796,1384329600"; 
   d="scan'208";a="451014168"
Message-ID: <52F4139A.5060404@intel.com>
Date: Thu, 06 Feb 2014 14:58:34 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Andrey Panin <pazke@donpac.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-visws-devel@lists.sf.net,
        Chris McDermott <lcm@linux.vnet.ibm.com>
Subject: Re: [patch 1/4] x86, apic: Only use default_wait_for_init_deassert
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com> <87txcc57y2.fsf@tassilo.jf.intel.com> <alpine.DEB.2.02.1402061430420.29446@chino.kir.corp.google.com> <52F40F21.8070200@zytor.com>
In-Reply-To: <52F40F21.8070200@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 02:39 PM, H. Peter Anvin wrote:
> On 02/06/2014 02:31 PM, David Rientjes wrote:
> I would love to see NumaQ, VisWS, Summit and ES7000 just nuked.  In
> fact, I'm thinking that unless someone steps up and explicitly claims
> ownership of those platforms by adding their name to MAINTAINERS (or
> reiterating them in the case of VisWS, which MAINTAINERS entry says "for
> 2.6") we should just rip them all out.
> 
> Anyone who wants to disagree?

I never knew of anyone who ran Linux on a NUMA-Q for anything other than
kernel development.  The systems that we had are, as far as I know, all
unplugged and scrapped somewhere.

The Summits were sold for fairly brief periods of time, and they're
surely not going to be supported hardware on enterprise distros from
here on out.  Chris McDermott would know for sure.
