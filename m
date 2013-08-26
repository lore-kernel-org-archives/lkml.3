Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab3HZOay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:30:54 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34087 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3HZOaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:30:52 -0400
MIME-Version: 1.0
Date: Mon, 26 Aug 2013 20:00:52 +0530
Message-ID: <CAKohponkO6oZrvrsUGVK0uUbAM5wse7eHd7udtWkab7y2aatGA@mail.gmail.com>
Subject: [Query] CPUFreq: Why do we need policy->user_policy?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

I am almost done with cleanup of drivers and am back at cpufreq core.. :)
I got to this structure: struct cpufreq_real_policy;

And I am not able to understand what's the need for this structure?
Can you let me know? Before I try to get rid of it :)

--
viresh
