Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628Ab3FNCLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:11:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22988 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3FNCLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:11:46 -0400
X-AuditID: cbfee68e-b7f276d000002279-0a-51ba7bdbcfb4
Message-id: <51BA7BDB.9070801@samsung.com>
Date: Fri, 14 Jun 2013 11:11:39 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [RESEND][PATCH] cpufreq: stats: Add 'load_table' sysfs file to
 show accumulated data of CPU
References: <1370419882-16831-1-git-send-email-cw00.choi@samsung.com>
 <11735265.3zXb8Z81XT@vostro.rjw.lan>
 <CAKohpomwDonECPOPoSZvrOS+mRyNARX4Sk1XoEAGLXrOQQjYjA@mail.gmail.com>
 <2801243.ZfLEluCnpU@vostro.rjw.lan>
In-reply-to: <2801243.ZfLEluCnpU@vostro.rjw.lan>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkWPdO9a5Ag2fTWCyeNv1gtzjb9Ibd
	4vKuOWwWn3uPMFrcblzBZtG/sJfJYuNXDwd2jzvX9rB59G1ZxejxaHELo8fnTXIBLFFcNimp
	OZllqUX6dglcGdevvmMueMtb0XZrKlMD4zTuLkYODgkBE4mZzSJdjJxAppjEhXvr2boYuTiE
	BJYySpw51ckKkTCRaGvoYYVITGeU+Ht3B5TzglGiZe5+RpAqXgEtiXM3FzKDTGURUJV49ykF
	JMwGFN7/4gYbiC0qECaxcvoVFohyQYkfk++B2SJA5Vue/GcHmckssIVR4uT/u+wgCWGBLIll
	835DLbvJKPHuWzPYAk4BA4mtmzRAapgF1CUmzVvEDGHLS2xe85YZpF5C4Bi7xKmnJ8ESLAIC
	Et8mH2KBeFlWYtMBZojPJCUOrrjBMoFRbBaSm2YhGTsLydgFjMyrGEVTC5ILipPSi4z0ihNz
	i0vz0vWS83M3MQJj7fS/Z307GG8esD7EmAy0ciKzlGhyPjBW80riDY3NjCxMTUyNjcwtzUgT
	VhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAWCN6cO/6W8FfO8vvmhxVdyr78nTr
	da+Gv3Ubl2avn6vExP+OI1to9ptvv9l3Lp0TOsFYNUVQWyL89VXWsx+0GOYuMTu1bcp53dNT
	2Rnb51+Ob9polyR3MODNp+q1i47liG4Jnr5h5XLGND7mxo/Fczl/PGA+suTuo+J70xjrFx9h
	Cos/yXng8zQlluKMREMt5qLiRABLQidjywIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQd3b1bsCDTZstLR42vSD3eJs0xt2
	i8u75rBZfO49wmhxu3EFm0X/wl4mi41fPRzYPe5c28Pm0bdlFaPHo8UtjB6fN8kFsEQ1MNpk
	pCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2gpFCWmFMK
	FApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcy4fvUdc8Fb3oq2W1OZGhincXcxcnJI
	CJhItDX0sELYYhIX7q1n62Lk4hASmM4o8ffuDlYI5wWjRMvc/YwgVbwCWhLnbi5k7mLk4GAR
	UJV49ykFJMwGFN7/4gYbiC0qECaxcvoVFohyQYkfk++B2SJA5Vue/GcHmckssIVR4uT/u+wg
	CWGBLIll835DLbvJKPHuWzPYAk4BA4mtmzRAapgF1CUmzVvEDGHLS2xe85Z5AqPALCQ7ZiEp
	m4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Fh+JrWDcWWDxSFGAQ5GJR7ehAs7
	A4VYE8uKK3MPMUpwMCuJ8Ib/BQrxpiRWVqUW5ccXleakFh9iTAaGwERmKdHkfGCaySuJNzQ2
	MTOyNDI3tDAyNidNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRpe4e99/Wi4tnmC9JnTh
	7f79zr/j9zF7boiWKgs/HG2qHssYv4DFPfp06smvJz5nbl+btOOpuezJdN8dja2/EsQXHuO6
	fqM1PpJR7Ua58Z7yOJMJXDfv32C9ernvvFeEbq+dXIDfrTNv5XKjor9vn6//4WGdltNkQw/L
	vJvr9h9Ztajg7t2LBUosxRmJhlrMRcWJAFRF7PYpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 08:05 PM, Rafael J. Wysocki wrote:
> On Wednesday, June 12, 2013 09:32:16 AM Viresh Kumar wrote:
>> On 12 June 2013 03:44, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> On Wednesday, June 05, 2013 05:11:22 PM Chanwoo Choi wrote:
>>>> This patch add new sysfs file to show previous accumulated data of CPU load
>>>> as following path. This sysfs file is used to judge the correct system state
>>>> or determine suitable system resource on user-space.
>>>> - /sys/devices/system/cpu/cpu0/cpufreq/stats/load_table
>>>>
>>>> This sysfs file include following data:
>>>> - Measurement point of time
>>>> - CPU frequency
>>>> - Per-CPU load
>>>>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>
>>> Well, first of all, there is the "one value per file" rule for sysfs attributes
>>> which is evidently violated by this code.
>>
>> Even this was enclosed in CONFIG_CPU_FREQ_STAT_DETAILS,
>> so even sysfs isn't that bad as we already had something similar here.
> 
> Yes, we did, and yes, it was a mistake.  It should have been in debugfs from
> the very beginning.
> 
>>> Second, this looks like a feature needed to handle one particular platform, so
>>> why do you want to add it to the cpufreq core?
>>
>> I really felt this would be useful to others. They can track the load on
>> all cores for some time and that will really be useful. People can
>> understand their loads and system more easily with this patch in.
> 
> If it were in debugfs, I'd have no objections.
> 

OK, I will reimplement load_table node by using debugfs instead of sysfs.

Thanks.

Best Regards,
Chanwoo Choi


