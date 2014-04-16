Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751124AbaDPEA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:00:26 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:43507 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaDPEAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:00:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140416012454.GA3941@verge.net.au>
References: <534DB238.5030201@semaphore.gr>
	<20140416011120.GC8833@verge.net.au>
	<20140416012454.GA3941@verge.net.au>
Date: Wed, 16 Apr 2014 09:30:24 +0530
Message-ID: <CAKohponxbA_rPFF=vzZEnjYkLLCkNOWHP7kxAUZ5mKpTPp_Myw@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] sh: clk: Use cpufreq_for_each_valid_entry macro
 for iteration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Simon Horman <horms@verge.net.au>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        SH-Linux <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 April 2014 06:54, Simon Horman <horms@verge.net.au> wrote:
> I have dropped this patch.
>
> Please let me know if there is a stable branch which
> includes cpufreq_frequency_table which I can use as a base to apply
> this patch.
>
> Alternatively, I would be happy to Ack this patch and let someone
> else pick up this patch, but I'm entirely unclear on who that would be.

Rafael will take this patch, please Ack it :)
