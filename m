Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761908Ab3DCGbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:31:50 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:59361 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761576Ab3DCGbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:31:48 -0400
Date: Wed, 03 Apr 2013 09:31:39 +0300
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
Message-ID: <ore61p9gvaic2j0fc083dpbd.1364970699079@email.android.com>
From: stratosk <stratosk@semaphore.gr>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r336VneZ025921

I'm sorry, I don't understand.
The goal of this patch is not energy saving.
The goal is to detect CPU load as soon as possible to increase frequency.

Could you please clarify this?

Thanks,
Stratos

"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

>On Tuesday, April 02, 2013 06:49:14 PM Stratos Karafotis wrote:
>> On 04/02/2013 04:50 PM, Rafael J. Wysocki wrote:
>> > Do you have any numbers indicating that this actually makes things better?
>> > 
>> > Rafael
>> 
>> No, I don't.
>> The expected behaviour after this patch is to "force" max frequency few sampling periods earlier.
>> The idea was to increase system responsiveness especially on 'small' embedded systems (phones for example).
>> 
>> Actually, I thought to provide some numbers but I had no idea how to measure this.
>> 
>> Would it be enough to provide the number of times that the CPU increases frequency 
>> because of early_demand versus the total number of increments?
>
>I think it would be better to check if your approach leads to a better behavior
>as far as energy savings are concerned.  If it actually is worse, then I don't
>see a reason to apply it.
>
>Thanks,
>Rafael
>
>
>-- 
>I speak only for myself.
>Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
