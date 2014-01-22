Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaAVJiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:38:50 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:50566 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbaAVJiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:38:46 -0500
Message-ID: <52DF914B.2060308@linux.vnet.ibm.com>
Date: Wed, 22 Jan 2014 15:07:15 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 0/8] Add support for PowerPC Hypervisor supplied performance
 counters
References: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com> <1390354379.11104.3.camel@concordia>
In-Reply-To: <1390354379.11104.3.camel@concordia>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012209-1618-0000-0000-0000054CD917
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 07:02 AM, Michael Ellerman wrote:
> On Thu, 2014-01-16 at 15:53 -0800, Cody P Schafer wrote:
>> These patches add basic pmus for 2 powerpc hypervisor interfaces to obtain
>> performance counters: gpci ("get performance counter info") and 24x7.
>>
>> The counters supplied by these interfaces are continually counting and never
>> need to be (and cannot be) disabled or enabled. They additionally do not
>> generate any interrupts. This makes them in some regards similar to software
>> counters, and as a result their implimentation shares some common code (which
>> an initial patch exposes) with the sw counters.
> 
> Hi Cody,
> 
> Can you please add some more explanation of this series.
> 
> In particular why do we need two new PMUs, and how do they relate to each
> other?
> 
> And can you add an example of how I'd actually use them using perf.
> 

Yeah, agreed.

