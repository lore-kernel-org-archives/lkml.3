Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaDDRIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:08:44 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:44107 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaDDRIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:08:42 -0400
Message-ID: <533EE700.4080408@hp.com>
Date: Fri, 04 Apr 2014 13:08:16 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Marcos Matsunaga <Marcos.Matsunaga@oracle.com>
Subject: Re: [PATCH v8 01/10] qspinlock: A generic 4-byte queue spinlock implementation
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com> <1396445259-27670-2-git-send-email-Waiman.Long@hp.com> <20140404130012.GE10526@twins.programming.kicks-ass.net> <20140404165727.GQ19478@phenom.dumpdata.com>
In-Reply-To: <20140404165727.GQ19478@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 12:57 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Apr 04, 2014 at 03:00:12PM +0200, Peter Zijlstra wrote:
>> So I'm just not ever going to pick up this patch; I spend a week trying
>> to reverse engineer this; I posted a 7 patch series creating the
>> equivalent, but in a gradual and readable fashion:
>>
>>    http://lkml.kernel.org/r/20140310154236.038181843@infradead.org
>>
>> You keep on ignoring that; I'll keep on ignoring your patches.
>>
>> I might at some point rewrite some of your pv stuff on top to get this
>> moving again, but I'm not really motivated to work with you atm.
> Uh? Did you CC also xen-devel@lists.xenproject.org on your patches Peter?
> I hadn't had a chance to see or comment on them :-(
>

Peter's patch is a rewrite of my patches 1-4, there is no PV or unfair 
lock support in there.

-Longman
