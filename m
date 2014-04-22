Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaDVHPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:15:50 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45909 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaDVHPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:15:47 -0400
Date: Tue, 22 Apr 2014 08:15:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v4 5/8] mfd: db8500-prcmu: Use cpufreq_for_each_entry
 macro for iteration
Message-ID: <20140422071541.GA17657@lee--X1>
References: <534DB213.7080802@semaphore.gr>
 <5355A349.50908@semaphore.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5355A349.50908@semaphore.gr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The cpufreq core now supports the cpufreq_for_each_entry macro helper
> for iteration over the cpufreq_frequency_table, so use it.
> 
> It should have no functional changes.

> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---

It would be good to have a changelog which describes the differences
between the versions, so we can keep track.

>  drivers/mfd/db8500-prcmu.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)

So it looks like I already applied v2 of this patch to my tree. What
changed in v3 and v4? Should I remove that patch from MFD and apply
this one instead?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
