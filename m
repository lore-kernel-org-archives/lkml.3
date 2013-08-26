Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab3HZOiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:38:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35008 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab3HZOiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:38:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: Re: [Query] CPUFreq: Why do we need policy->user_policy?
Date: Mon, 26 Aug 2013 16:48:48 +0200
Message-ID: <20581731.mdSQ720dHi@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohponkO6oZrvrsUGVK0uUbAM5wse7eHd7udtWkab7y2aatGA@mail.gmail.com>
References: <CAKohponkO6oZrvrsUGVK0uUbAM5wse7eHd7udtWkab7y2aatGA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 26, 2013 08:00:52 PM Viresh Kumar wrote:
> Hi Rafael,

Hi,

> I am almost done with cleanup of drivers and am back at cpufreq core.. :)
> I got to this structure: struct cpufreq_real_policy;
> 
> And I am not able to understand what's the need for this structure?
> Can you let me know? Before I try to get rid of it :)

Honestly, I don't remember from the top of my head.

Thanks,
Rafael

