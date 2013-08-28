Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3H1Fm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:42:56 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:64805 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab3H1Fmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:42:55 -0400
MIME-Version: 1.0
In-Reply-To: <1734682.b8u1f0b3XY@vostro.rjw.lan>
References: <CAKohponkO6oZrvrsUGVK0uUbAM5wse7eHd7udtWkab7y2aatGA@mail.gmail.com>
	<CAKohpo=ZKA6ieg9BrVRCRL+_7uiPfb2tWMO0_VOYx0m=Sv4+xQ@mail.gmail.com>
	<CAOLK0pztfCd9ov297t0CW0C5S2iOSb9FJFHq9ycqwYGRiyifmA@mail.gmail.com>
	<1734682.b8u1f0b3XY@vostro.rjw.lan>
Date: Wed, 28 Aug 2013 11:12:54 +0530
Message-ID: <CAKohpokJzEMKuupBunzBSQTRJ-4D=xeLHyyH3C9E1tSLJuJBwg@mail.gmail.com>
Subject: Re: [Query] CPUFreq: Why do we need policy->user_policy?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lan Tianyu <lantianyu1986@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 August 2013 02:50, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, August 27, 2013 10:04:52 PM Lan Tianyu wrote:

>> From my understanding.policy->min/max may be modified by some drivers
>> but the user_policy only store user space config and should not be changed
>> by other reason.  :)
>
> Yes, that was the original idea IIRC, so separate user settings from stuff that
> may be changed internally by the kernel.

Yeah, that's what I understood too now.. Anyway I am going to do some core
cleanups now, drivers are mostly done and will see if something can be done
to get rid of them... Otherwise will keep them as is.
