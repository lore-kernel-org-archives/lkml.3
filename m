Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaDDO7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:59:38 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:42791 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaDDO7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:59:36 -0400
Message-ID: <533EC8BD.8080601@hp.com>
Date: Fri, 04 Apr 2014 10:59:09 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v8 01/10] qspinlock: A generic 4-byte queue spinlock implementation
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com> <1396445259-27670-2-git-send-email-Waiman.Long@hp.com> <20140404130012.GE10526@twins.programming.kicks-ass.net>
In-Reply-To: <20140404130012.GE10526@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 09:00 AM, Peter Zijlstra wrote:
> So I'm just not ever going to pick up this patch; I spend a week trying
> to reverse engineer this; I posted a 7 patch series creating the
> equivalent, but in a gradual and readable fashion:
>
>    http://lkml.kernel.org/r/20140310154236.038181843@infradead.org
>
> You keep on ignoring that; I'll keep on ignoring your patches.
>
> I might at some point rewrite some of your pv stuff on top to get this
> moving again, but I'm not really motivated to work with you atm.

Peter, I am sorry that I have focused recently on making the qspinlock 
patch works with virtualization and it is easier for me to based off on 
my patch initially. Now the PV part is almost done, I will apply them on 
top of your patch. Hopefully, I will get a new patch out sometime next week.

I am really sorry if you have bad feeling about it. I do not mean to 
discredit you on your effort to make the qspinlock patch better. I 
really appreciate your input and would like to work with you on this 
patch as well as other future patches.

-Longman
