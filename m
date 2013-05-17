Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab3EQNwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:52:09 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:36013 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3EQNwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:52:06 -0400
MIME-Version: 1.0
In-Reply-To: <10164364.7LZaY8si4T@vostro.rjw.lan>
References: <cover.1368679353.git.viresh.kumar@linaro.org>
	<4482296.g7Mb85DDVP@vostro.rjw.lan>
	<CAKohpomOzeHsv=ZDBJGQKAiFWHDczweWF1wZuQDMRZE-0U3=2A@mail.gmail.com>
	<10164364.7LZaY8si4T@vostro.rjw.lan>
Date: Fri, 17 May 2013 19:22:05 +0530
Message-ID: <CAKohpo=bNzYw5ire+6XnM+cv6fnPBDN-CX0DRonc5qhpKC01yA@mail.gmail.com>
Subject: Re: [PATCH 0/3] CPUFreq Fixes for 3.10-rc2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 May 2013 17:46, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, May 17, 2013 10:13:37 AM Viresh Kumar wrote:
>> On 17 May 2013 02:21, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > While I kind of understand why you want [3/3] to go into 3.10, I'm wondering
>> > about the other two patches.  Why exactly are they needed now?
>>
>> First one:
>>
>>   cpufreq: Add EXPORT_SYMBOL_GPL for have_governor_per_policy
>>
>> is required so that governors can be compiled as module. Otherwise they
>> may break.. I haven't tried that but I believe that is the case.
>
> Did you try to build them as modules?

That's what: "I haven't tried that but I believe that is the case."..
Modules need variables to be exported with EXPORT_SYMBOL_GPL
to be used by them.. And I thought this is pretty straight forward.
