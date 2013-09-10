Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab3IJHJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:09:46 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:57637 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3IJHJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:09:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130906195353.26919.76123.stgit@srivatsabhat.in.ibm.com>
References: <20130906195206.26919.20884.stgit@srivatsabhat.in.ibm.com>
	<20130906195353.26919.76123.stgit@srivatsabhat.in.ibm.com>
Date: Tue, 10 Sep 2013 12:39:43 +0530
Message-ID: <CAKohpon96ecA3L9ux0tnFngPbWDmrVfW3xUWf_3aZ5qYZGXLVw@mail.gmail.com>
Subject: Re: [PATCH 4/5] cpufreq: Remove temporary fix for race between CPU
 hotplug and sysfs-writes
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Boyd <sboyd@codeaurora.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 September 2013 01:23, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Commit "cpufreq: serialize calls to __cpufreq_governor()" had been a temporary
> and partial solution to the race condition between writing to a cpufreq sysfs
> file and taking a CPU offline. Now that we have a proper and complete solution
> to that problem, remove the temporary fix.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---

I would still vote for keeping this code or reverting this patch of yours..
As there might be other scenarios, than hotplug races, where this serialization
would be useful..

--
viresh
