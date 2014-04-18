Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161022AbaDRVkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:40:41 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:16710 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbaDRVkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:40:36 -0400
Message-ID: <53519BBF.7060506@hp.com>
Date: Fri, 18 Apr 2014 17:40:15 -0400
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
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v9 05/19] qspinlock: Optimize for smaller NR_CPUS
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com> <1397747051-15401-6-git-send-email-Waiman.Long@hp.com> <20140417155649.GR11096@twins.programming.kicks-ass.net> <53504BB3.4010009@hp.com> <20140418082716.GZ11096@twins.programming.kicks-ass.net> <53516672.3010701@hp.com> <20140418190519.GA11182@twins.programming.kicks-ass.net>
In-Reply-To: <20140418190519.GA11182@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 03:05 PM, Peter Zijlstra wrote:
> On Fri, Apr 18, 2014 at 01:52:50PM -0400, Waiman Long wrote:
>> I am confused by your notation.
> Nah, I think I was confused :-) Make the 1 _Q_LOCKED_VAL though, as
> that's the proper constant to use.

Everyone gets confused once in a while:-) I have plenty of that myself.

I will change 1 to _Q_LOCKED_VAL as suggested.

-Longman
