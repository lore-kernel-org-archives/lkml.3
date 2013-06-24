Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3FXKmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:42:32 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58813 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3FXKma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:42:30 -0400
MIME-Version: 1.0
In-Reply-To: <1524748.bV9OZAOR0D@vostro.rjw.lan>
References: <CAKohpo=v4qPDH32Y4ithr_p007nTn5AOUzkUCiHTGgQN6-=BEw@mail.gmail.com>
	<1524748.bV9OZAOR0D@vostro.rjw.lan>
Date: Mon, 24 Jun 2013 16:12:29 +0530
Message-ID: <CAKohpomThmZFKTufBzWpmokqqZJ8C6DtGTKTzBY=OxJPNT-BmA@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: CPUFreq updates for 3.11
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2013 16:19, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, June 24, 2013 11:20:35 AM Viresh Kumar wrote:
>> Hi Rafael,
>>
>> This is part of my patchset "CPUFreq: Fix {PRE|POST}CHANGE notification
>> sequence". It contains changes specific to cpufreq core and ARM drivers.
>>
>> I have left changes to non-ARM cpufreq drivers from this pull request. See if
>> you can take them for 3.11.
>>
>> The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:
>>
>>   Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)
>>
>> are available in the git repository at:
>>
>>   git://git.linaro.org/people/vireshk/linux.git cpufreq-fix-notification-arm
>>
>> for you to fetch changes up to f2d65dd0d573e6961165f0be35bac84997b9e707:
>
> Well, this contains changes that aren't specific to ARM as far as I can say.

Yeah, the first patch touches core. How do you want to proceed with this one
then? You will apply them from mail? Or you will apply first patch (core cpufreq
one) and I should send pull request without it?
