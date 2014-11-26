Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaKZFcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 00:32:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22204 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaKZFcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 00:32:04 -0500
X-AuditID: cbfee68d-f79296d000004278-19-547565d2fb5c
Message-id: <547565BF.3040304@samsung.com>
Date: Wed, 26 Nov 2014 11:01:43 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Jaewon Kim <jaewon02.kim@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dan Murphy <dmurphy@ti.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Hyunhee Kim <hyunhee.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] Input: add regulator haptic driver
References: <1416840651-17141-1-git-send-email-jaewon02.kim@samsung.com>
 <1416840651-17141-2-git-send-email-jaewon02.kim@samsung.com>
In-reply-to: <1416840651-17141-2-git-send-email-jaewon02.kim@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWyRsSkWvdSammIwY1f/BbXvzxntTi86AWj
	RffpLawWnz+0sFvsaDjCatG74Cqbxc1P31gtLu+aw2Yx4/w+JgdOj52z7rJ79G1Zxehx/MZ2
	Jo/Pm+QCWKK4bFJSczLLUov07RK4Mib3/2IpWCNeMf/sL+YGxqtCXYycHBICJhJN+xrYIWwx
	iQv31rN1MXJxCAksZZTY0vGLFaZo2eIJzBCJRYwSTYteMUE4rUwS3ReOsoFU8QpoSdx+eg1s
	FIuAqsSbZd9YQGw2AV2JJ+/nMoPYogIRElfWzGGEqBeU+DH5HgvIIBGBF0Drfj5nAkkwC5RJ
	7Jz+AqxIWMBOYnXHcqib2hkllvz6A5bgFPCUWPh1FztEg63EgvfrWCBseYnNa96C3SohcIld
	4sLnJkaIkwQkvk0+BFTEAZSQldh0gBniN0mJgytusExgFJuF5KhZSMbOQjJ2ASPzKkbR1ILk
	guKk9CJDveLE3OLSvHS95PzcTYzAODz971nvDsbbB6wPMQpwMCrx8EZIlYYIsSaWFVfmHmI0
	BbpiIrOUaHI+MNrzSuINjc2MLExNTI2NzC3NlMR5FaV+BgsJpCeWpGanphakFsUXleakFh9i
	ZOLglGpgjFm5a89DC5nJs/dfqbBzqpQX5rbff33pipjcZZ6OG6Qr104MFwjedqrD7/+9OW1O
	9x0rO5/GG30TeRy9eIli7fPtIs8+/b3uveapoVCcjc5CwWstmQdzxDVTLq5KXHdHVElJJPiF
	9cu6tfr37vAol9//d5PraS/7M+9XmyZXbPv/7Ptchj9KD5VYijMSDbWYi4oTAYMfxLe+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAd1LqaUhBhv2sVpc//Kc1eLwoheM
	Ft2nt7BafP7Qwm6xo+EIq0XvgqtsFjc/fWO1uLxrDpvFjPP7mBw4PXbOusvu0bdlFaPH8Rvb
	mTw+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5gxuf8XS8Ea8Yr5
	Z38xNzBeFepi5OSQEDCRWLZ4AjOELSZx4d56ti5GLg4hgUWMEk2LXjFBOK1MEt0XjrKBVPEK
	aEncfnqNHcRmEVCVeLPsGwuIzSagK/Hk/VywSaICERJX1sxhhKgXlPgx+R4LyCARgReMElt+
	PmcCSTALlEnsnP4CrEhYwE5idcdyqNXtjBJLfv0BS3AKeEos/LqLHaLBVmLB+3UsELa8xOY1
	b5knMArMQrJkFpKyWUjKFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIjvJn0jsYVzVY
	HGIU4GBU4uGNkCoNEWJNLCuuzD3EKMHBrCTC6xMHFOJNSaysSi3Kjy8qzUktPsRoCgyDicxS
	osn5wASUVxJvaGxibmpsamliYWJmqSTOe+NmboiQQHpiSWp2ampBahFMHxMHp1QDo3TPq8f7
	bA4WhJ0/yBDr8PhEi8rHsJ6OrftuRr9a1GlYEDNznviSi4eU6wV2yKxZIpGruYRbf8ZziS1T
	net7Reecn7OIz/jIjWSFl0UvemqPLFD5Kyf5YZnRrabkZboBCY4HZBoi2EUfcG30aeIxPXrp
	b4PbKtGX90MjZvzYsd6/hP2IC+fCm0osxRmJhlrMRcWJAPWi470IAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaewon,

On Monday 24 November 2014 08:20 PM, Jaewon Kim wrote:
> This patch adds support for haptic driver controlled by
> voltage of regulator. And this driver support for
> Force Feedback interface from input framework
>
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   .../devicetree/bindings/input/regulator-haptic.txt |   24 ++
>   drivers/input/misc/Kconfig                         |   11 +
>   drivers/input/misc/Makefile                        |    1 +
>   drivers/input/misc/regulator-haptic.c              |  247 ++++++++++++++++++++
>   include/linux/input/regulator-haptic.h             |   30 +++
>   5 files changed, 313 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/input/regulator-haptic.txt
>   create mode 100644 drivers/input/misc/regulator-haptic.c
>   create mode 100644 include/linux/input/regulator-haptic.h
>
> diff --git a/Documentation/devicetree/bindings/input/regulator-haptic.txt b/Documentation/devicetree/bindings/input/regulator-haptic.txt
> new file mode 100644
> index 0000000..5a44e8f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/regulator-haptic.txt
> @@ -0,0 +1,24 @@
> +* Requlator Haptic Device Tree Bindings

Nit: %s/Requlator/Regulator

> +
> +The regulator haptic driver controlled by voltage of regulator.
> +This driver implemented via Force Feedback interface.
> +

[Snip]

> diff --git a/include/linux/input/regulator-haptic.h b/include/linux/input/regulator-haptic.h
> new file mode 100644
> index 0000000..15a629c
> --- /dev/null
> +++ b/include/linux/input/regulator-haptic.h
> @@ -0,0 +1,30 @@
> +/*
> + * Regulator Haptic Platform Data
> + *
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + * Author: Jaewon Kim <jaewon02.kim@samsung.com>
> + * Author: Hyunhee Kim <hyunhee.kim@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef _REGULATOR_HAPTIC_H
> +

Please define _REGULATOR_HAPTIC_H here as:
#define _REGULATOR_HAPTIC_H

> +/*
> + * struct regulator_haptic_data - Platform device data
> + *
> + * @regulator: Power supply to the haptic motor
> + * @max_volt: maximum voltage value supplied to the haptic motor.
> + * 		<The unit of the voltage is a micro>
> + * @min_volt: minimum voltage value supplied to the haptic motor.
> + * 		<The unit of the voltage is a micro>
> + */
> +struct regulator_haptic_data {
> +	struct regulator *regulator;
> +	unsigned int max_volt;
> +	unsigned int min_volt;
> +};
> +
> +#endif /* _REGULATOR_HAPTIC_H */
>

With these two minor fixes please feel free to add:

Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>


Thanks,
Pankaj Dubey
