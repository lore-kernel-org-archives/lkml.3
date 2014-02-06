Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbaBFW63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:58:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48423 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166AbaBFW61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:58:27 -0500
Message-ID: <52F41368.7060801@zytor.com>
Date: Thu, 06 Feb 2014 14:57:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Andrey Panin <pazke@donpac.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-visws-devel@lists.sf.net
Subject: Re: [patch 1/4] x86, apic: Only use default_wait_for_init_deassert
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com> <87txcc57y2.fsf@tassilo.jf.intel.com> <alpine.DEB.2.02.1402061430420.29446@chino.kir.corp.google.com> <52F40F21.8070200@zytor.com> <alpine.DEB.2.02.1402062342190.21991@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402062342190.21991@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 02:52 PM, Thomas Gleixner wrote:
>>
>> I would love to see NumaQ, VisWS, Summit and ES7000 just nuked.  In
>> fact, I'm thinking that unless someone steps up and explicitly claims
>> ownership of those platforms by adding their name to MAINTAINERS (or
>> reiterating them in the case of VisWS, which MAINTAINERS entry says "for
>> 2.6") we should just rip them all out.
>>
>> Anyone who wants to disagree?
> 
> Anyone who disagrees is automatically appointed to fill in the vacancy
> in that section of the maintainers file:
> 
> PALEONTOLOGICAL SYSTEMS
> M:      vacant@paleontological.systems
> S:      reanimation
> 

... and *do the work*, too.  Just having a MAINTAINERS entry isn't
enough, as we have seen many times in the past.

	-hpa

