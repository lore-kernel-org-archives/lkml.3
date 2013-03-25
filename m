Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab3CYKdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:33:08 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:48441 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab3CYKdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:33:06 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
Date: Mon, 25 Mar 2013 16:03:05 +0530
Message-ID: <CAKohpo=9QAvWc9kpqDSWwANx_v9zVpOKDGKD3j+kApJVwXAJtw@mail.gmail.com>
Subject: Re: [PATCH 0/9] ARM: CPUFreq: Move drivers arch/arm/ -> drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 March 2013 15:41, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This patchset tries to move all CPUFreq drivers for ARM platforms from arch/arm
> to drivers/cpufreq directory.
>
> This series is dependent (rebased of) on following patches:
>
> http://www.spinics.net/lists/arm-kernel/msg232540.html
> https://lkml.org/lkml/2013/3/24/151
>
> I want this series to go through Rafael's tree due to dependencies and so want
> Ack's by respective maintainers.
>
> These are applied here for people looking to test them:
>
> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-move-drivers

These are compile tested only :)
