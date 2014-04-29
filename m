Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaD2E6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:58:06 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:50157 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaD2E6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:58:04 -0400
MIME-Version: 1.0
In-Reply-To: <535D80C8.9090906@semaphore.gr>
References: <535D80C8.9090906@semaphore.gr>
Date: Tue, 29 Apr 2014 10:28:02 +0530
Message-ID: <CAKohpomhUk7RQ3YL3=wpVKSbK_oSkyYBRUZiqnHzWqrZ2DjRRA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: intel_pstate: Change the calculation of next pstate
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'd Dirk,

On 28 April 2014 03:42, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Currently the driver calculates the next pstate proportional to
> core_busy factor and reverse proportional to current pstate.
>
> Change the above method and calculate the next pstate independently
> of current pstate.

We must mention why the change is required.
