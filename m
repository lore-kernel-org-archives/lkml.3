Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422721Ab3CVRaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:30:39 -0400
Received: from void.printf.net ([89.145.121.20]:54501 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422663Ab3CVRai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:30:38 -0400
From: Chris Ball <cjb@laptop.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH V3 5/7] mmc: queue work on any cpu
References: <cover.1363617402.git.viresh.kumar@linaro.org>
	<08070dbf56439c84b8c25837c2049ff8e8eafd6e.1363617402.git.viresh.kumar@linaro.org>
	<87vc8jjqhc.fsf@octavius.laptop.org>
	<CAKohpomqkYeMgvTpjrUjGs3md=vzguW5Ae6Snf4hzsqtQxNDOw@mail.gmail.com>
Date: Fri, 22 Mar 2013 13:30:32 -0400
In-Reply-To: <CAKohpomqkYeMgvTpjrUjGs3md=vzguW5Ae6Snf4hzsqtQxNDOw@mail.gmail.com>
	(Viresh Kumar's message of "Fri, 22 Mar 2013 22:57:49 +0530")
Message-ID: <87r4j7jq9z.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 22 2013, Viresh Kumar wrote:
> On 22 March 2013 22:56, Chris Ball <cjb@laptop.org> wrote:
>> On Mon, Mar 18 2013, Viresh Kumar wrote:
>>
>> /home/cjb/git/mmc/drivers/mmc/core/core.c: In function
>> ‘mmc_schedule_delayed_work’:
>> /home/cjb/git/mmc/drivers/mmc/core/core.c:88:2: error: implicit
>> declaration of function ‘queue_delayed_work_on_any_cpu’
>> [-Werror=implicit-function-declaration]
>>
>> I've dropped this patch for now.  This function doesn't seem to be
>> defined in linux-next either.
>
> Hi chris,
>
> This patch was part of a bigger patchset which also adds this API. I
> don't want you to
> apply this one but just Ack here. Probably Tejun or some scheduler
> maintainer will
> apply it later (if they like all patches).

Thanks, makes sense.  For [5/7]:

Acked-by: Chris Ball <cjb@laptop.org>

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
