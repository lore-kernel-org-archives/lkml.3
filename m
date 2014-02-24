Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaBXIqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:46:03 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:44179 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbaBXInX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:43:23 -0500
MIME-Version: 1.0
In-Reply-To: <a7536f7b5a03fe287aaf1974db74ba64.squirrel@www.codeaurora.org>
References: <1393225072-3997-1-git-send-email-skannan@codeaurora.org>
	<530AF7E4.5080806@linux.vnet.ibm.com>
	<CAKohpok-8_JV8hRDiWnRLYqEqyvD60cyn5Hs1HcZTSEPZjLvOQ@mail.gmail.com>
	<a7536f7b5a03fe287aaf1974db74ba64.squirrel@www.codeaurora.org>
Date: Mon, 24 Feb 2014 14:13:22 +0530
Message-ID: <CAKohpomRqboKjHRF8ev9erJ6MdRWcsX2jO7A=g47gMmewm_ZiQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Set policy to non-NULL only after all hotplug
 online work is done
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 February 2014 14:11,  <skannan@codeaurora.org> wrote:
> I just replied to the other email. I think I answered both your questions
> there. Sorry about mixing up CPU and policy. In my case, each CPU is
> independently scalable -- so for now take CPU == policy. I'll fix it up
> once we agree on the fix.

But why do you say this then?

>>> In this specific case, CPU0 set's CPU1's policy->governor in
>>> cpufreq_init_policy() to NULL while CPU1 is using the policy->governor
>>> in __cpufreq_governor().
