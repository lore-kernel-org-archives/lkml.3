Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaFJRss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:48:48 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:57655 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751002AbaFJRsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:48:46 -0400
Message-ID: <539744FB.1000307@semaphore.gr>
Date: Tue, 10 Jun 2014 20:48:43 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] cpufreq: intel_pstate: Simplify code in intel_pstate_adjust_busy_pstate
References: <5396207D.7030704@semaphore.gr> <CAKohpokYB4oKxrEwHH888T5hg=zrpb0PCs_QKTLS0bd-_fqeTA@mail.gmail.com> <53971B8E.4040302@semaphore.gr> <53973B67.5020802@gmail.com>
In-Reply-To: <53973B67.5020802@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 08:07 μμ, Dirk Brandewie wrote:
> On 06/10/2014 07:51 AM, Stratos Karafotis wrote:
>> On 10/06/2014 08:27 πμ, Viresh Kumar wrote:
>>> On 10 June 2014 02:30, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>>>> Simplify the code by removing the inline functions
>>>> pstate_increase and pstate_decrease and use directly the
>>>> intel_pstate_set_pstate.
>>>>
> 
> Doesn't apply without your scaled_busy change spin this patch with
> out the scaled_busy change and explain the change more fully in the
> commit message to cover Viresh's question and I am good with this change.
> 
> 

OK, I will.

Thanks,
Stratos

