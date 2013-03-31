Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3CaN7D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 09:59:03 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:34413 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450Ab3CaN7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 09:59:00 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Mar 2013 09:58:55 EDT
Message-ID: <60902.128.237.120.215.1364739533.squirrel@mprc.pku.edu.cn>
In-Reply-To: <CAKohpo=MCn4qBMg9ZsSzmDvg0-7eE063u6g=btuCgC6G8x2rmQ@mail.gmail.com>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
    <27c30dd79c668dc3471d37fce2c83a4504d8b18c.1364229828.git.viresh.kumar@linaro.org>
    <CAKohpo=MCn4qBMg9ZsSzmDvg0-7eE063u6g=btuCgC6G8x2rmQ@mail.gmail.com>
Date: Sun, 31 Mar 2013 22:18:53 +0800 (CST)
Subject: Re: [PATCH 7/9] unicore2: cpufreq: move cpufreq driver to 
     drivers/cpufreq
From: "Xuetao Guan" <gxt@mprc.pku.edu.cn>
To: "Viresh Kumar" <viresh.kumar@linaro.org>
Cc: "Guan Xuetao" <gxt@mprc.pku.edu.cn>, arvind.chauhan@arm.com,
        robin.randhawa@arm.com, steve.bannister@arm.com, liviu.dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, arnd.bergmann@linaro.org,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Reply-To: gxt@mprc.pku.edu.cn
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=gb2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 25 March 2013 22:24, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> This patch moves cpufreq driver of UNICORE-2 architecture to
>> drivers/cpufreq.
>>
>> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  arch/unicore32/kernel/Makefile
>> | 1 -
>>  drivers/cpufreq/Makefile
>> | 1 +
>>  arch/unicore32/kernel/cpu-ucv2.c => drivers/cpufreq/unicore2-cpufreq.c
>> | 2 +-
>>  3 files changed, 2 insertions(+), 2 deletions(-)
>>  rename arch/unicore32/kernel/cpu-ucv2.c =>
>> drivers/cpufreq/unicore2-cpufreq.c (96%)
>
> Guan,
>
> Can i have your ack for this?
>
Sure. Sorry for my delay.

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

