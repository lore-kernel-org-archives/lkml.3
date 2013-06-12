Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab3FLLt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 07:49:56 -0400
Received: from multi.imgtec.com ([194.200.65.239]:15475 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3FLLtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 07:49:55 -0400
Message-ID: <51B8605A.60402@imgtec.com>
Date: Wed, 12 Jun 2013 12:49:46 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: add const qualifier to perf_pmu_register's 'name'
 arg
References: <1370339148-5566-1-git-send-email-mjonker@synopsys.com> <20130604095801.GM8923@twins.programming.kicks-ass.net> <51ADBB1D.9060805@synopsys.com> <20130604110314.GN8923@twins.programming.kicks-ass.net> <51ADCAD1.8090900@synopsys.com> <20130604111816.GP8923@twins.programming.kicks-ass.net>
In-Reply-To: <20130604111816.GP8923@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_12_12_49_48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/13 12:18, Peter Zijlstra wrote:
> On Tue, Jun 04, 2013 at 04:39:05PM +0530, Vineet Gupta wrote:
>> On 06/04/2013 04:33 PM, Peter Zijlstra wrote:
>>> Simlar 'complaint' for the ARC stuff really, only marketing speak :-) 
>>
>> You mean lack of prefix in this case (as opposed to MetaG).
> 
> Nah, lack of proper (!markting speak) introduction to the arch ;-)
> 
> Is there something like the Intel SDM for these archs,

For metag, see the patchset intro for a brief (hopefully !marketing)
intro and links to documentation. Meta is the marketing name, metag is
generally used in code which reduces ambiguity with the word meta - tbh
I'm not certain whether metag is short for metagence or means something
else, but it's been that way for years now.

http://lwn.net/Articles/534906/

> if so, do we want
> to make it easier to find them for people?

Where would you suggest?

Some other arches link to the linux-$ARCH project homepages in Kconfig
help text which makes sense as that can then link to various
documentation and be more easily kept up to date. Not all arches have a
big project around them like that though.

Cheers
James

