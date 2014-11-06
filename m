Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaKFHBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:01:32 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:38443 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaKFHB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:01:29 -0500
MIME-Version: 1.0
In-Reply-To: <10546062.ah0Qvxpsuh@wuerfel>
References: <1413377405-7503-1-git-send-email-dbaryshkov@gmail.com>
	<10546062.ah0Qvxpsuh@wuerfel>
Date: Thu, 6 Nov 2014 11:01:29 +0400
Message-ID: <CALT56yOKFcRLZpTHiy-3n8+e=0GY=d_Y9r4ghe_bn5B2vYv+yQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] clocksource: enable pxa_timer for SA-1100 platform
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2014-10-20 23:07 GMT+04:00 Arnd Bergmann <arnd@arndb.de>:
> On Wednesday 15 October 2014 16:50:04 Dmitry Eremin-Solenikov wrote:
>> SA-11x0 platform used the same IP block as was used on PXA. Consequently
>> it makes sense to have only one driver. Enable pxa_timer clocksource for
>> StrongARM platform.
>>
>> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>
> Both patches look good to me.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> Should we merge them through arm-soc or through the clocksource tree?


Thomas added his blessing (and an ack) to merge these patches through arm-soc.
Should I gather any additional Acks before it cn hit arm-soc/for-next?

-- 
With best wishes
Dmitry
