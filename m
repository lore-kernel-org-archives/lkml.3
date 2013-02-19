Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab3BSKIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:08:14 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:47804 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab3BSKIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:08:12 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw+KOg1z_bx=WFLpY5mhJ2AiAfEa5FW6XsU8YBKfUWThg@mail.gmail.com>
References: <20130213193411.GA15928@redhat.com>
	<CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
	<20130215011503.GA11914@redhat.com>
	<CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com>
	<20130215174435.GA2792@linux.vnet.ibm.com>
	<CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com>
	<CAFTL4hyTfwAZWz=gMokk5oG3HO8iGh7=FtoNv89CMg_Lm-TPNg@mail.gmail.com>
	<CA+55aFz4vO-JGv+A7h=uxwfyWEMcK=Q3gntwHfr=a4OUVs-f+g@mail.gmail.com>
	<CAFTL4hx7iX8vZFu7pO5wLSPpEzfMD8K7n0bUsY-wK-uCsDAsEw@mail.gmail.com>
	<CAFTL4hzUy+2qDaCDK3jCUs+6Fe48-uU9KSB+Ssk+-i=zYhqaRg@mail.gmail.com>
	<20130218155324.GA5816@somewhere.redhat.com>
	<CA+55aFw+KOg1z_bx=WFLpY5mhJ2AiAfEa5FW6XsU8YBKfUWThg@mail.gmail.com>
Date: Tue, 19 Feb 2013 11:08:10 +0100
Message-ID: <CAFTL4hw_rs7WLx_yav6aAE-AhS1bLvbup4k7UfPAs3j+sjBYvw@mail.gmail.com>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/18 Linus Torvalds <torvalds@linux-foundation.org>:
> On Mon, Feb 18, 2013 at 7:53 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>
>> Here is an updated version. It cleans up things a bit and boots fine with my usual
>> config. There might be still some small details to work on but here is the big picture.
>>
>> What do you think?
>
> Looks fine to me. Did this get tested with lockdep and spinlock
> debugging etc? Those are the ones that are the primary users of all
> the irq state and preempt tracing..

Yeah I always keep those options turned on to test my patches. But I
need to test with and without preempt, check if I can reuse more
local_bh_disable, etc... So there will be more iterations.
