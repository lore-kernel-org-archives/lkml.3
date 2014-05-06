Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050AbaEFFCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 01:02:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14198 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaEFFCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 01:02:21 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-a1-53686cdd1fd6
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Thomas Gleixner'" <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>
References: <5619084.0zmrrIUZLV@wuerfel>
In-reply-to: <5619084.0zmrrIUZLV@wuerfel>
Subject: RE: [PATCH] provide irq_force_affinity fallback for non-SMP
Date: Tue, 06 May 2014 14:02:20 +0900
Message-id: <0fda01cf68e8$5c1364f0$143a2ed0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLh0FwerZIbiI5iuzuKiXWsqiiNzJkOL84g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zQ927ORnBBnO/sVr8nXSM3eL1C0OL
	y7vmsFls3jSV2YHF4/evSYwe786dY/fo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujLXXHrAW
	bOGpePSvn6mBcRZXFyMnh4SAiUTHyZtMELaYxIV769m6GLk4hASWMUocXT4bKMEBVtT/2B0i
	vohRYsrVXmaQBiGBv4wSbw97gthsAhoSh98/YwexRQS8JV5umcoCYjMLBEus3f+aEaJeQ+LQ
	r9tsIDangKbE2XPLwOLCAi4S0+ZfADuCRUBVYsusWWC9vAKWElsO7mKGsAUlfky+BzVTS2L9
	zuNMELa8xOY1b5khHlCQ2HEWYpeIgJFE86cp7BA1IhL7XrxjBHlAQuAcu8SmY+fZIZYJSHyb
	fIgF4klZiU0HoOZIShxccYNlAqPELCSrZyFZPQvJ6llIVixgZFnFKJpakFxQnJReZKxXnJhb
	XJqXrpecn7uJERKT/TsY7x6wPsSYDLR+IrOUaHI+MKbzSuINjc2MLExNTI2NzC3NSBNWEue9
	/zApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjAo8tl3ZMyhHZsm/K4XqWBfmbPus3Vax9
	sI9ve7njx0Y5uTtPjgr6Kb6dFb2ruEJrdZqN1Gu/Vfx73mYUbqj9bhr7eQfbj5q8xIwjEXa8
	HM/mXVl42bvjY1LwzrsPHkRcupHpZOd32WdK5TeD7DcyD/XattnKMVjHzf522yju9O7JIjqx
	D4ROK7EUZyQaajEXFScCALjk3EffAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd27ORnBBuumMVn8nXSM3eL1C0OL
	y7vmsFls3jSV2YHF4/evSYwe786dY/fo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xoy11x6wFmzhqXj0r5+pgXEWVxcjB4eEgIlE/2P3LkZOIFNM4sK9
	9WxdjFwcQgKLGCWmXO1lBkkICfxllHh72BPEZhPQkDj8/hk7iC0i4C3xcstUFhCbWSBYYu3+
	14wQ9RoSh37dZgOxOQU0Jc6eWwYWFxZwkZg2/wITiM0ioCqxZdYssF5eAUuJLQd3MUPYghI/
	Jt+DmqklsX7ncSYIW15i85q3zBCHKkjsOAuxS0TASKL50xR2iBoRiX0v3jFOYBSahWTULCSj
	ZiEZNQtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwRH/THoH46oGi0OMAhyMSjy8
	J1amBwuxJpYVV+YeYpTgYFYS4fV3yggW4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5HxgMsor
	iTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBkbbX+eCt7w+r/bj
	bfw2nYk7OV8WGN/byj0v/le8WbLAfB6WZ4k5cgkl6R5Pbp1YGTzXTCkwIkJ4zibtsj4+hrvB
	SVOyNR+veK+0P0DqRObCqZYB3t/Els21sgs7+2Ftg/QEgbjLC6oqOKutvURPHDLr2vS12O37
	nQdqa6Tzs28d3RhnI3r2iYkSS3FGoqEWc1FxIgDsYQIcPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> Patch 01f8fa4f01d "genirq: Allow forcing cpu affinity of interrupts" added
> an irq_force_affinity() function, and 30ccf03b4a6 "clocksource:
Exynos_mct:
> Use irq_force_affinity() in cpu bringup" subsequently uses it. However,
> the
> driver can be used with CONFIG_SMP disabled, but the function declaration
> is only available for CONFIG_SMP, leading to this build error:
> 
> drivers/clocksource/exynos_mct.c:431:3: error: implicit declaration of
> function 'irq_force_affinity' [-Werror=implicit-function-declaration]
>    irq_force_affinity(mct_irqs[MCT_L0_IRQ + cpu], cpumask_of(cpu));
> 
> This patch introduces a dummy helper function for the non-SMP case
> that always returns success, to get rid of the build error.
> Since the patches causing the problem are marked for stable backports,
> this one should be as well.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Arnd, thanks for your fix the build error.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

- Kukjin

> Cc: stable@vger.kernel.org
> ---
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 0e6b23f..b72a643 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -272,6 +272,11 @@ static inline int irq_set_affinity(unsigned int irq,
> const struct cpumask *m)
>  	return -EINVAL;
>  }
> 
> +static inline int irq_force_affinity(unsigned int irq, const struct
> cpumask *cpumask)
> +{
> +	return 0;
> +}
> +
>  static inline int irq_can_set_affinity(unsigned int irq)
>  {
>  	return 0;

