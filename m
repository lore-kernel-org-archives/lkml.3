Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763728Ab3DDHWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:22:08 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:37829 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763173Ab3DDHWF (ORCPT
	<rfc822;	linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:22:05 -0400
Date: Thu, 04 Apr 2013 10:21:55 +0300
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
Message-ID: <6abgl9p3kyb9lrgptch39iyw.1365060115568@email.android.com>
From: stratosk <stratosk@semaphore.gr>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r347MB3V000968

I agree that we will have false alarms but this will not be a total waste of power since the load will be more than 50 (the default grad_up_threshold value).

So, I don't think there will be *significant* increase in power. Though, I don't know a way to prove this with numbers.

Thanks,
Stratos

Viresh Kumar <viresh.kumar@linaro.org> wrote:

>On 4 April 2013 12:17, stratosk <stratosk@semaphore.gr> wrote:
>> Why do you suspect significant increased power? With ondemand  the CPU will go down to lowest freq as soon as the load will decreased. And the measurement shows that the CPU load will decrease faster (because of faster calculation).
>
>I suspect it because we are increasing freq based on the assumption:
>"If increase in load from last calculation is more then threshold, then
>we must use high freq"..
>
>So, this rise can be false alarm multiple times and we might not see
>a load increase after moving to high freq and so we are running at
>high/max freq without any need of it. And so more power.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
