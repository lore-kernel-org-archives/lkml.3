Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaEHRzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:55:21 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:51481 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaEHRzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:55:19 -0400
Message-ID: <536BC4EF.9040208@hp.com>
Date: Thu, 08 May 2014 13:54:55 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 00/19] qspinlock: a 4-byte queue spinlock with PV
 support
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com> <20140507190723.GB16333@phenom.dumpdata.com>
In-Reply-To: <20140507190723.GB16333@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 03:07 PM, Konrad Rzeszutek Wilk wrote:
> On Wed, May 07, 2014 at 11:01:28AM -0400, Waiman Long wrote:
>> v9->v10:
>>    - Make some minor changes to qspinlock.c to accommodate review feedback.
>>    - Change author to PeterZ for 2 of the patches.
>>    - Include Raghavendra KT's test results in patch 18.
> Any chance you can post these on a git tree? Thanks.

I have pushed the bit to https://github.com/longman88/kernel-qspinlock-v10 .

-Longman

