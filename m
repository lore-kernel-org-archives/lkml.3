Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbaCDDnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 22:43:35 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:57877 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbaCDDnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 22:43:33 -0500
MIME-Version: 1.0
In-Reply-To: <7507031.JAfx7W3apJ@vostro.rjw.lan>
References: <9f9546137135103556c69815c72b81ed93cc1ca2.1393318100.git.viresh.kumar@linaro.org>
	<7507031.JAfx7W3apJ@vostro.rjw.lan>
Date: Tue, 4 Mar 2014 09:13:32 +0530
Message-ID: <CAKohpo=RPh9rpWdTbAAiUQoeSugMTb-4W2hZXHzTcaD5yVEnjA@mail.gmail.com>
Subject: Re: [PATCH 1/3] cpufreq: move call to __find_governor() to cpufreq_init_policy()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 March 2014 06:39, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> And while I'm at it, can we *please* avoid adding new #ifdef blocks into
> function bodies?
>
> Please introduce a wrapper around __find_governor() returning NULL for
> CONFIG_HOTPLUG_CPU unset.

I have tried fixing all the suggestions you gave for this series. Please have a
look at V2 set and let me know if I am still missing anything.
