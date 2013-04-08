Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934224Ab3DHEyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:54:41 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:40039 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3DHEyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:54:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokk1Q+0gRpeW=ts0a8D+rGAUpHu62X+7ejdpfom_B6FYA@mail.gmail.com>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
	<927100d30bf40d4fec477cc7d8d464669a22d167.1365079581.git.viresh.kumar@linaro.org>
	<2a5901ce31c9$95160980$bf421c80$%kim@samsung.com>
	<CAKohpokk1Q+0gRpeW=ts0a8D+rGAUpHu62X+7ejdpfom_B6FYA@mail.gmail.com>
Date: Mon, 8 Apr 2013 10:24:38 +0530
Message-ID: <CAKohpomgqWi9jfpqtW8cxu7BeJQCEySqbdDNVK=4Fh1ji1FyMg@mail.gmail.com>
Subject: Re: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: rjw@sisk.pl, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Ben Dooks <ben-linux@fluff.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 April 2013 12:36, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 5 April 2013 12:18, Kukjin Kim <kgene.kim@samsung.com> wrote:
>> Basically, this moving looks good to me, but should be re-worked based on
>> for-next of samsung tree because this touches too many samsung stuff so this
>> should be sent to upstream via samsung tree.
>
> Hmm... Its already applied in Rafael's tree. But it doesn't mean that
> it can't be
> moved to your tree if there is a issue.
>
> What tree/branch? I used:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git for-next
>
>> Applying: cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
>> error: patch failed: arch/arm/Kconfig:2166
>> error: arch/arm/Kconfig: patch does not apply
>
> above two are obvious as you haven't applied other patches in this series.
>
>> error: patch failed: arch/arm/mach-s3c24xx/Kconfig:28
>> error: arch/arm/mach-s3c24xx/Kconfig: patch does not apply
>> error: patch failed: arch/arm/mach-s3c24xx/Makefile:17
>> error: arch/arm/mach-s3c24xx/Makefile: patch does not apply
>> error: patch failed: drivers/cpufreq/Makefile:63
>> error: drivers/cpufreq/Makefile: patch does not apply
>
> Same here.
>
>> error: drivers/cpufreq/s3c2412-cpufreq.c: does not exist in index
>
> I can still see it in for-next.
>
> Attached is my patch based of your for-next

Kukjin,

As Rafael has already dropped it, can you apply it at your end and make sure
it doesn't miss the merge cycle?
