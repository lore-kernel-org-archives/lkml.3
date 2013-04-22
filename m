Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3DVUym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:54:42 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:41805 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3DVUyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:54:40 -0400
Message-ID: <5175A38D.4070002@hp.com>
Date: Mon, 22 Apr 2013 13:54:37 -0700
From: Chegu Vinod <chegu_vinod@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiannan Ouyang <ouyang@cs.pitt.edu>
CC: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Karen Noel <knoel@redhat.com>
Subject: Re: Preemptable Ticket Spinlock
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com> <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop> <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop> <517595FA.800@redhat.com> <1366661294.6454.18.camel@laptop> <51759E43.2080003@redhat.com> <1366663475.8337.10.camel@laptop> <CAJocwcf2=+oWmn3EvNnCA5U81LPA=Ue8=RNYDJb_J6wNYmgNMQ@mail.gmail.com>
In-Reply-To: <CAJocwcf2=+oWmn3EvNnCA5U81LPA=Ue8=RNYDJb_J6wNYmgNMQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/2013 1:50 PM, Jiannan Ouyang wrote:
> On Mon, Apr 22, 2013 at 4:44 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Mon, 2013-04-22 at 16:32 -0400, Rik van Riel wrote:
>>> IIRC one of the reasons was that the performance improvement wasn't
>>> as obvious.  Rescheduling VCPUs takes a fair amount of time, quite
>>> probably more than the typical hold time of a spinlock.
>> IIRC it would spin for a while before blocking..
>>
>> /me goes re-read some of that thread...
>>
>> Ah, its because PLE is curing most of it.. !PLE it had huge gains but
>> apparently nobody cares about !PLE hardware anymore :-)
>>
> For now, I don't know how good it can work with PLE. But I think it
> should save the time of VMEXIT on PLE machine.
> .
>
Thanks for sharing your patch. 'am waiting for your v2 patch(es) and 
then let you any review feedback. Hoping to verify your changes on a 
large box (PLE enabled) and get back to you with some data...

Thanks
Vinod
