Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3FEJfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:35:43 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:60950 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752829Ab3FEJfm (ORCPT
	<rfc822;	linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:35:42 -0400
Date: Wed, 05 Jun 2013 12:35:27 +0300
Subject: Re: [PATCH v2 2/3] cpufreq: Remove unused function
 __cpufreq_driver_getavg
Message-ID: <v6q3yh4g49poaxn58wac6mqx.1370424863903@email.android.com>
From: Stratos Karafotis <stratosk@semaphore.gr>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, " H. Peter Anvin" <hpa@zytor.com>,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r559Zo0M027299

I think you are right. I will reorder 2/3 and 3/3 with the change you suggested.

Thanks,
Stratos

Viresh Kumar <viresh.kumar@linaro.org> wrote:

>On 4 June 2013 20:36, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>> On 06/04/2013 08:19 AM, Viresh Kumar wrote:
>>> Should this be done in 3/3 ?
>>>
>>
>> acpi-cpufreq does not use mperf after 2/3. Why should we compile it with
>> CONFIG_X86_ACPI_CPUFREQ?
>> Do you want me to move the change in 3/3?
>
>I somehow feel now that 3/3 should come before 2/3 and then this change
>should be merged into it. And at the end we can have this patch as 3/3..
>
>What do you say? core should go last and users/drivers must go first.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
