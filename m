Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaD3EG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 00:06:58 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:39928 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaD3EG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:06:56 -0400
MIME-Version: 1.0
In-Reply-To: <535FE72D.2020402@semaphore.gr>
References: <535FE72D.2020402@semaphore.gr>
Date: Wed, 30 Apr 2014 09:36:55 +0530
Message-ID: <CAKohpo=YHon_WgaM6dm8jU1dw8uasRLekt-YKD63RMrMu9f0Uw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: intel_pstate: Remove sample parameter in intel_pstate_calc_busy
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 April 2014 23:23, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Since commit d37e2b7644 ("intel_pstate: remove unneeded sample buffers")
> we use only one sample. So, there is no need to pass the sample
> pointer to intel_pstate_calc_busy. Instead, get the pointer from
> cpudata. Also, remove the unused SAMPLE_COUNT macro.
>
> While at it, reformat the first line in this function.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/intel_pstate.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
