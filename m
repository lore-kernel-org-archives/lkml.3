Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbaGQXX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:23:28 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44894 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044AbaGQXX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:23:27 -0400
Message-ID: <53C85AE6.7080600@au1.ibm.com>
Date: Fri, 18 Jul 2014 09:23:18 +1000
From: Sam Bobroff <sam.bobroff@au1.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        Peter Zijlstra <peterz@infradead.org>, Pedro Alves <palves@redhat.com>,
        oleg@redhat.com, akpm@linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dhowells@redhat.com, Linux PPC dev <linuxppc-dev@ozlabs.org>,
        davej@redhat.com, tglx@linutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH V3 0/3] Add new PowerPC specific ELF core notes
References: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com> <53996E41.4070309@linux.vnet.ibm.com> <53C7A4FA.4030600@linux.vnet.ibm.com> <1405595380.25310.21.camel@pasglop> <CAEjGV6yK_9DS1cLQ2BH=HFi029N8rz-4Wyvwzdb_gy6PnJgbwg@mail.gmail.com>
In-Reply-To: <CAEjGV6yK_9DS1cLQ2BH=HFi029N8rz-4Wyvwzdb_gy6PnJgbwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071723-3568-0000-0000-000005E62393
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/14 21:14, Michael Neuling wrote:
> 
> On Jul 17, 2014 9:11 PM, "Benjamin Herrenschmidt"
> <benh@kernel.crashing.org <mailto:benh@kernel.crashing.org>> wrote:
>>
>> > >
>> > >> Outstanding Issues
>> > >> ==================
>> > >> (1) Running DSCR register value inside a transaction does not
> seem to be saved
>> > >>     at thread.dscr when the process stops for ptrace examination.
>> > >
>> > > Hey Ben,
>> > >
>> > > Any updates on this patch series ?
>> >
>> > Ben,
>> >
>> > Any updates on this patch series ?
>>
>> I haven't had a chance to review yet, I was hoping somebody else would..
>>
>> Have you made any progress vs. the DSCR outstanding issue mentioned
>> above ?
> 
> The DSCR issue should be resolved with Sam Bobroff's recent  DSCR
> fixes.  I've not tested them though.
> 
> Actually... Sam did you review this series?
> 
> Mikey
> 

I did, and applying "powerpc: Correct DSCR during TM context switch"
corrected the DSCR value in the test program (the one in the patch notes
for this series).

(In fact, IIRC, the reason for my patch set was the bug exposed by this
one ;-)

Cheers,
Sam.


