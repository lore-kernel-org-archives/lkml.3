Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3H0KXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:23:05 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:62399 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab3H0KXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:23:03 -0400
MIME-Version: 1.0
Date: Tue, 27 Aug 2013 15:53:01 +0530
Message-ID: <CAKohpo=OuYK7vhoG6a4REd-XuGMP63NTKhd8TWJmKo1R6rDp7g@mail.gmail.com>
Subject: [Query-CPUIdle]: Not much activity in C0 state
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Suresh.Srinivasan@arm.com, Amit Kucheria <amit.kucheria@linaro.org>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

I was trying to run following on my thinkpad:

watch -n1 cat /sys/devices/system/cpu/cpu*/cpuidle/state*/usage

I can see lots of activities on State 1-4, but not much on state 0..
I thought we should enter this state as soon as we come out to
non-idle state.. And so this count must be changing quite rapidly.

Is this a bug?

--
viresh
