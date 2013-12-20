Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab3LTP4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:56:41 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:54323 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab3LTP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:56:37 -0500
MIME-Version: 1.0
In-Reply-To: <2118684.kuZSLHD0UA@vostro.rjw.lan>
References: <c6b53b186145559668722120ea1f37d28ddb3177.1387516043.git.viresh.kumar@linaro.org>
	<2118684.kuZSLHD0UA@vostro.rjw.lan>
Date: Fri, 20 Dec 2013 21:26:35 +0530
Message-ID: <CAKohpo=pBUCXNUce6DiZAJU4yshVJdPiKfMWk77nKHGuMusqgA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: remove sysfs files for CPU which failed to come
 back after resume
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 December 2013 20:44, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> Well, this just looks odd.  Please do
>
>         return sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");

Yeah, that was stupid :)
