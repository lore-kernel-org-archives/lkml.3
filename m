Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3ILGbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:31:17 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:40405 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3ILGbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:31:15 -0400
MIME-Version: 1.0
In-Reply-To: <52315D7D.3030406@linux.vnet.ibm.com>
References: <20130911201239.7832.72612.stgit@srivatsabhat.in.ibm.com>
	<20130911201334.7832.49714.stgit@srivatsabhat.in.ibm.com>
	<CAKohpomgd8X4UwFaVtJ49=CXTg2cyEirvD4_mj5ohqS5fk064Q@mail.gmail.com>
	<52315D7D.3030406@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 12:01:14 +0530
Message-ID: <CAKohpoktJkAWf2xvRKmz3ZUW3wiRqHYdaR6d_HKsXZPXiiK53Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] cpufreq: Prevent problems in update_policy_cpu() if
 last_cpu == new_cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 11:51, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> That said, indeed currently there is no code in cpufreq that invokes the
> function with last == new. So its not like we are masking an existing bug with
> this patch. If you like, perhaps we can change this patch to print a warning
> when it gets input values with last == new? That prevents disasters and also
> warns when some code is buggy. Sounds like a win-win.

Exactly what I thought while I was midway reading your mail :)
Probably a WARN().. So that we don't miss any other bugs :)
