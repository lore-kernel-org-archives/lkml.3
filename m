Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaEVEBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:01:36 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54693 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaEVEBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:01:35 -0400
Message-ID: <537D762F.1080100@linux.vnet.ibm.com>
Date: Thu, 22 May 2014 09:29:43 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Fwd: [V6 00/11] perf: New conditional branch filter
References: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com> <537C6DDE.9000204@linux.vnet.ibm.com> <20140521092313.GF30445@twins.programming.kicks-ass.net> <537C827B.9090505@linux.vnet.ibm.com> <20140521120146.GD2485@laptop.programming.kicks-ass.net>
In-Reply-To: <20140521120146.GD2485@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052204-5490-0000-0000-00000020330F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 05:31 PM, Peter Zijlstra wrote:
> On Wed, May 21, 2014 at 04:09:55PM +0530, Anshuman Khandual wrote:
>> On 05/21/2014 02:53 PM, Peter Zijlstra wrote:
>>> On Wed, May 21, 2014 at 02:41:58PM +0530, Anshuman Khandual wrote:
>>>> Hello Peter/Ingo,
>>>>
>>>> Would you please consider reviewing the first four patches in this patch series
>>>> which changes the generic perf kernel and perf tools code. Andi Kleen and Stephane
>>>> Eranian have already reviewed these changes. The rest of the patch series is related
>>>> to powerpc and being reviewed by Michael Ellerman/Ben.
>>>>
>>>
>>> If they land in my inbox I might have a look.
>>>
>>
>> Sent.
> 
> Thanks, they look fine to me, although 1/x can use a lightly longer
> changelog, making it explicit its a filter for conditional branches.
> 
> How do people want this routed? Should I take all patches through tip,
> or do I ask Ingo to create a special perf/cond branch which includes the
> first 4 patches which can be merged into whatever ppc branch and the
> rest then go on top in the ppc tree?
> 

Peter,

Thanks for considering the patchset.

