Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaDRSNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 14:13:15 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:4215 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaDRSNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 14:13:11 -0400
Message-ID: <53516B24.3060108@hp.com>
Date: Fri, 18 Apr 2014 14:12:52 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
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
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v9 03/19] qspinlock: Add pending bit
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com> <1397747051-15401-4-git-send-email-Waiman.Long@hp.com> <20140418074255.GA13517@gmail.com> <53515181.8090303@hp.com> <20140418163543.GA6208@phenom.dumpdata.com>
In-Reply-To: <20140418163543.GA6208@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 12:35 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Apr 18, 2014 at 12:23:29PM -0400, Waiman Long wrote:
>> On 04/18/2014 03:42 AM, Ingo Molnar wrote:
>>> * Waiman Long<Waiman.Long@hp.com>   wrote:
>>>
>>>> Because the qspinlock needs to touch a second cacheline; add a pending
>>>> bit and allow a single in-word spinner before we punt to the second
>>>> cacheline.
>>>>
>>>> Signed-off-by: Peter Zijlstra<peterz@infradead.org>
>>>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
>>> This patch should have a "From: Peter" in it as well, right?
>>>
>>> Thanks,
>>>
>>> 	Ingo
>> Do you mean a "From:" line in the mail header? It will be a bit hard
>> to have different "From:" header in the same patch series. I can
>> certainly do that if there is an easy way to do it.
> It is pretty easy.
>
> Just do 'git commit --amend --author "The Right Author"' and when
> you send the patches (git send-email) it will include that.

Thank for the tip. I will do that in the next version.

-Longman
