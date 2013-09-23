Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab3IWKCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:02:14 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:57111 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab3IWKCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:02:13 -0400
MIME-Version: 1.0
In-Reply-To: <524010CF.6030605@freescale.com>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
	<70ae3eb991bded7c9768ae7934973943c2a1bf05.1379779777.git.viresh.kumar@linaro.org>
	<524010CF.6030605@freescale.com>
Date: Mon, 23 Sep 2013 15:32:12 +0530
Message-ID: <CAKohpomDFvxnR7x8qdDGqvrkJB9eRBU0RVGijRfLAdOgEPwdqg@mail.gmail.com>
Subject: Re: [PATCH 05/21] cpuidle: make __cpuidle_driver_init() return void
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Hongbo Zhang <hongbo.zhang@freescale.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 September 2013 15:28, Hongbo Zhang <hongbo.zhang@freescale.com> wrote:
> On 09/22/2013 09:20 AM, Viresh Kumar wrote:
>>
>> __cpuidle_driver_init() doesn't return anything except zero and so doesn't
>> really need a return type other than void.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>   drivers/cpuidle/driver.c | 8 ++------
>>   1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
>> index 25455e8..8df66c8 100644
>> --- a/drivers/cpuidle/driver.c
>> +++ b/drivers/cpuidle/driver.c
>> @@ -152,7 +152,7 @@ static void cpuidle_setup_broadcast_timer(void *arg)
>>    *
>>    * Returns 0 on success, a negative error code otherwise.
>
> If you want to make it return void, you should also update the above
> comment.

Thanks for the correction..
