Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422705Ab3CVR1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:27:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58744 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422663Ab3CVR1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:27:50 -0400
MIME-Version: 1.0
In-Reply-To: <87vc8jjqhc.fsf@octavius.laptop.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
	<08070dbf56439c84b8c25837c2049ff8e8eafd6e.1363617402.git.viresh.kumar@linaro.org>
	<87vc8jjqhc.fsf@octavius.laptop.org>
Date: Fri, 22 Mar 2013 22:57:49 +0530
Message-ID: <CAKohpomqkYeMgvTpjrUjGs3md=vzguW5Ae6Snf4hzsqtQxNDOw@mail.gmail.com>
Subject: Re: [PATCH V3 5/7] mmc: queue work on any cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chris Ball <cjb@laptop.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 March 2013 22:56, Chris Ball <cjb@laptop.org> wrote:
> On Mon, Mar 18 2013, Viresh Kumar wrote:
>
> /home/cjb/git/mmc/drivers/mmc/core/core.c: In function ‘mmc_schedule_delayed_work’:
> /home/cjb/git/mmc/drivers/mmc/core/core.c:88:2: error: implicit declaration of function ‘queue_delayed_work_on_any_cpu’ [-Werror=implicit-function-declaration]
>
> I've dropped this patch for now.  This function doesn't seem to be
> defined in linux-next either.

Hi chris,

This patch was part of a bigger patchset which also adds this API. I
don't want you to
apply this one but just Ack here. Probably Tejun or some scheduler
maintainer will
apply it later (if they like all patches).
