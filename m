Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3GJLhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:37:05 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:40879 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3GJLhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:37:02 -0400
Message-ID: <51DD482E.30605@linux.vnet.ibm.com>
Date: Wed, 10 Jul 2013 17:10:30 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: Andrew Jones <drjones@redhat.com>, mingo@redhat.com, ouyang@cs.pitt.edu,
        habanero@linux.vnet.ibm.com, jeremy@goop.org, x86@kernel.org,
        konrad.wilk@oracle.com, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, xen-devel@lists.xensource.com,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
References: <1372171802.3804.30.camel@oc2024037011.ibm.com> <51CAAA26.4090204@linux.vnet.ibm.com> <20130626113744.GA6300@hawk.usersys.redhat.com> <20130626125240.GY18508@redhat.com> <51CAEF45.3010203@linux.vnet.ibm.com> <20130626161130.GB18152@redhat.com> <51CB2AD9.5060508@linux.vnet.ibm.com> <51DBD3C2.2040807@linux.vnet.ibm.com> <20130710103325.GP24941@redhat.com> <20130710104047.GP25631@dyad.programming.kicks-ass.net> <20130710104717.GR24941@redhat.com> <51DD455D.4000701@linux.vnet.ibm.com>
In-Reply-To: <51DD455D.4000701@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071011-1618-0000-0000-0000043CF0DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dropping stephen becuase of bounce

On 07/10/2013 04:58 PM, Raghavendra K T wrote:
> On 07/10/2013 04:17 PM, Gleb Natapov wrote:
>> On Wed, Jul 10, 2013 at 12:40:47PM +0200, Peter Zijlstra wrote:
>>> On Wed, Jul 10, 2013 at 01:33:25PM +0300, Gleb Natapov wrote:
>>>
>>> Here's an idea, trim the damn email ;-) -- not only directed at gleb.
>>>
>> Good idea.
>>
>>>>> Ingo, Gleb,
>>>>>
>>>>>  From the results perspective, Andrew Theurer, Vinod's test results
>>>>> are
>>>>> pro-pvspinlock.
>>>>> Could you please help me to know what will make it a mergeable
>>>>> candidate?.
>>>>>
>>>> I need to spend more time reviewing it :) The problem with PV
>>>> interfaces
>>>> is that they are easy to add but hard to get rid of if better solution
>>>> (HW or otherwise) appears.
>>>
>>> How so? Just make sure the registration for the PV interface is
>>> optional; that
>>> is, allow it to fail. A guest that fails the PV setup will either
>>> have to try
>>> another PV interface or fall back to 'native'.
>>>

Forgot to add. Yes currently pvspinlocks are not enabled by default and
also, we have jump_label mechanism to enable it.
[...]

