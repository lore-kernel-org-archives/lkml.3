Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbaJOBkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 21:40:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64452 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbaJOBkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 21:40:22 -0400
X-AuditID: cbfee68d-f79296d000004278-8d-543dd07aba36
Message-id: <543DD079.4090306@samsung.com>
Date: Wed, 15 Oct 2014 10:40:09 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>
Cc: Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>, chris@printf.net,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: dw_mmc: Change signal voltage error to dev_dbg()
References: <1413000976-2038-1-git-send-email-dianders@chromium.org>
In-reply-to: <1413000976-2038-1-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsWyRsSkULfqgm2Iwcb/XBbL/n9nsngwbxub
	xYTL2xktzi47yGZxedccNosj//sZLZ6cmclo8eH+RWaL42vDHTg9ZjdcZPG4c20Pm8eNVwuZ
	PP7O2s/i0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBlbNt1lKejkqOhu3cPawLiLrYuRg0NC
	wESi9bpaFyMnkCkmceHeeqAwF4eQwFJGiUuTTrDA1PTvDYaIL2KU+NR4nBnCec0ocWXeAXaQ
	bl4BLYmFH1ezgtgsAqoSc49/ZQKx2QR0JLZ/Ow5miwqESRxqm8cEUS8o8WPyPRYQW0SgXKJx
	6wmwzcwCe4E23F7LDJIQFvCSWD7pIpgtJOAisbLnGlgzp4CrROvXeWDLmIEW7G+dxgZhy0ts
	XvMW7DoJgUfsEpfOzYK6SEDi2+RDUO/ISmw6wAzxsqTEwRU3WCYwis1CctMsJGNnIRm7gJF5
	FaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZgTJ7+96x3B+PtA9aHGAU4GJV4eDkO2IYIsSaW
	FVfmHmI0BbpiIrOUaHI+MPLzSuINjc2MLExNTI2NzC3NlMR5FaV+BgsJpCeWpGanphakFsUX
	leakFh9iZOLglGpgLJhm3L0+pKOi6upD3TCnaIspIe/YgvK2O/Wu/FrbXv75o2TD7v9z7Lbq
	+GxLcTp3THzd5xLuA/ycAQ/Ock8+u2+pQwT3MvmpOudkTjy2T2iR3vfBbrPN9k+vOeQKLlu3
	3+P2npr9eFHFXuUFDpntnT/Ls9by5kr2FCh3NTRwHngSeORYUvFDJZbijERDLeai4kQA59E7
	F8QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAd2qC7YhBvfWM1ss+/+dyeLBvG1s
	FhMub2e0OLvsIJvF5V1z2CyO/O9ntHhyZiajxYf7F5ktjq8Nd+D0mN1wkcXjzrU9bB43Xi1k
	8vg7az+LR9+WVYwenzfJBbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp
	5CXmptoqufgE6Lpl5gBdpaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM
	2LLpLktBJ0dFd+se1gbGXWxdjBwcEgImEv17g7sYOYFMMYkL99YDhbk4hAQWMUp8ajzODOG8
	ZpS4Mu8AO0gVr4CWxMKPq1lBbBYBVYm5x78ygdhsAjoS278dB7NFBcIkDrXNY4KoF5T4Mfke
	C4gtIlAu0bj1BNgGZoG9QBtur2UGSQgLeEksn3QRzBYScJFY2XMNrJlTwFWi9es8sGXMQAv2
	t05jg7DlJTavecs8gVFgFpIds5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZG
	cMw/k97BuKrB4hCjAAejEg8vxwHbECHWxLLiytxDjBIczEoivGlHgUK8KYmVValF+fFFpTmp
	xYcYTYFBMJFZSjQ5H5iO8kriDY1NzIwsjcwNLYyMzZXEeQ+2WgcKCaQnlqRmp6YWpBbB9DFx
	cEo1MPYXN3W+q91fGXQi6MWjdBHXhmtmlfncWdtecPEviVjwxuB49c4r0n7d+Ykvwmz0+6qm
	tfzbyHZG0fpc1C+um18Mavan/jq7cPuf3f3ntxSyWd8XLHkzeVHy30/uD4NnTBaV37d0m6pP
	jEf8mplTd81+vI7Xdk+q8HK3Bs6w0CCn2q82bkfP9CmxFGckGmoxFxUnAgB105h6DwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung

On 10/11/2014 01:16 PM, Doug Anderson wrote:
> In (28f92b5 mmc: core: Try other signal levels during power up) we can
> see that there are times when it's valid to try several signal
> voltages.  Don't print an ugly error in the logs when that happens.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 69f0cc6..c4afbdd 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1075,7 +1075,7 @@ static int dw_mci_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
>  		ret = regulator_set_voltage(mmc->supply.vqmmc, min_uv, max_uv);
>  
>  		if (ret) {
> -			dev_err(&mmc->class_dev,
> +			dev_dbg(&mmc->class_dev,
>  					 "Regulator set error %d: %d - %d\n",
>  					 ret, min_uv, max_uv);
>  			return ret;
> 

