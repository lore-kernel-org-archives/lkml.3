Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaEUEf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:35:58 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36055 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaEUEf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <537B9B0B.1020404@semaphore.gr>
References: <537B9B0B.1020404@semaphore.gr>
Date: Wed, 21 May 2014 10:05:55 +0530
Message-ID: <CAKohpo=MtRn_hb2WK0kRK3wJHt7_JrQvz=GRR4RpKZ_GJVOiGg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: intel_pstate: Remove unused member name of cpudata
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org >> LKML" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2014 23:42, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Although, a value is assigned to member name of struct cpudata,
> it is never used.
>
> We can safely remove it.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/intel_pstate.c | 4 ----
>  1 file changed, 4 deletions(-)

Looks fine to me atleast, lets see what Dirk will say :)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
