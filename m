Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab3DYQs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:48:28 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:33474 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758864Ab3DYQsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:48:25 -0400
Message-ID: <51795E53.5030908@samsung.com>
Date: Fri, 26 Apr 2013 01:48:19 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Kukjin Kim <kgene.kim@samsung.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        robin.randhawa@arm.com, Ben Dooks <ben-linux@fluff.org>,
        linux-pm@vger.kernel.org, patches@linaro.org, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steve.Bannister@arm.com,
        arvind.chauhan@arm.com, linaro-kernel@lists.linaro.org,
        charles.garcia-tobin@arm.com
Subject: Re: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
References: <cover.1365079581.git.viresh.kumar@linaro.org> <1769336.FkfMpuXqqb@vostro.rjw.lan> <5176A807.2090005@samsung.com> <2264237.NUtkmvZG3W@vostro.rjw.lan>
In-Reply-To: <2264237.NUtkmvZG3W@vostro.rjw.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/13 07:59, Rafael J. Wysocki wrote:

[...]

>> Rafael, please take this patch with my ack in your tree, sorry for noise.
>>
>> Acked-by: Kukjin Kim<kgene.kim@samsung.com>
>>
>> If any problems, please kindly let me know.
>
> Well, I suppose I can take the original patch, but then it will conflict with
> your tree during merge.  Is that not a problem?
>
I think, some conflicts can be occurred but if so, we can fix it before 
merge window.

- Kukjin
