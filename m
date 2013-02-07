Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab3BGEXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 23:23:06 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47195 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3BGEXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 23:23:03 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7fb06d000000f28-a5-51132c2471b1
Content-transfer-encoding: 8BIT
Message-id: <51132C20.80302@samsung.com>
Date: Thu, 07 Feb 2013 13:22:56 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it,
        Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: max8997: Add driver for max8997 rtc.
References: <1360149785-19645-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAHdPZaOLJJYDwsaLadvCnLe=-Hr+_HpRPXHebm3jgQtPO4WASg@mail.gmail.com>
In-reply-to: <CAHdPZaOLJJYDwsaLadvCnLe=-Hr+_HpRPXHebm3jgQtPO4WASg@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zPV0VHeFAg7nPeSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGnAWv2Qt2SFT8vv+RtYHxp0AXIyeHhICJxMYnE5khbDGJC/fW
	s3UxcnEICSxjlFg2ZTcbTNHKzdtZIBLTGSWuvmpkAUnwCghK/Jh8D8jm4GAWkJc4cikbJMws
	oC4xad4iZoj6LiaJc+0HGSHqNSTufT0F1ssioCpx9v0esDibgJzE26ZvjCBzRAUiJH71c4CE
	RQR0Jf6fn8QOMbNe4svzfjBbWMBOYs+0BVDz+xkl1n7exwSS4BQIlrhxeCErSEJCoJld4n3H
	C1aIZQIS3yYfAjtUQkBWYtMBqI8lJQ6uuMEygVFsFpJ3ZiG8MwvJOwsYmVcxiqYWJBcUJ6Xn
	GukVJ+YWl+al6yXn525ihESE9A7GVQ0WhxgFOBiVeHhvLhUKFGJNLCuuzD3EKMHBrCTCm/0U
	KMSbklhZlVqUH19UmpNafIgxGei+icxSosn5wGjNK4k3NDYwNjS0NDQztTQ1IE1YSZyX8dST
	ACGB9MSS1OzU1ILUIpgtTBycUg2M2mGLbap1PnYsmTprS+DpHTcd9X0b59879bUzW25vyaOF
	jW//MhrdeGre9u9TcrfcDwPZPgPlabf1PQ4XTPrC/eme5nxh7bKG+Tyl6xYuXHBofcONsHn3
	Co5bRrFNX/bz1K45z9nPn52yNmzLbr5tM/NO8EYt6fgQ79xos/KtJleVu8ubp1slJiuxFGck
	GmoxFxUnAgAcN3yNzAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jQV0VHeFAg5lfWC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxpwFr9kLdkhU/L7/kbWB
	8adAFyMnh4SAicTKzdtZIGwxiQv31rN1MXJxCAlMZ5S4+qoRLMErICjxY/I9IJuDg1lAXuLI
	pWyQMLOAusSkeYuYIeq7mCTOtR9khKjXkLj39RRYL4uAqsTZ93vA4mwCchJvm74xgswRFYiQ
	+NXPARIWEdCV+H9+EjvEzHqJL8/7wWxhATuJPdMWQM3vZ5RY+3kfE0iCUyBY4sbhhawTGAVm
	ITlvFsJ5s5Cct4CReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcLw9k97BuKrB4hCjAAej
	Eg/vzaVCgUKsiWXFlbmHGCU4mJVEeLOfAoV4UxIrq1KL8uOLSnNSiw8xJgM9N5FZSjQ5H5gK
	8kriDY1NzIwsjcyMTcyNjUkTVhLnZTz1JEBIID2xJDU7NbUgtQhmCxMHp1QDI9uE0vNrbX1f
	cKaeDyx5nutl//m9vKfRLzXvT9PVGN7VfpddzfEkwGyp/2Rbh/J5k6/ySz08l5sa33H8scoq
	xuPpmvmfn7O6MbYbV26c82pXhPTV7zsEmsscDq1mWKhzRqDJsvObvtNOZtaZYp3Bs18ZVb3u
	SIh8ffaxSMeBqIWCtzIPisY5KLEUZyQaajEXFScCAKT7VTH7AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 02월 07일 13:14, devendra.aaru wrote:
> Hello,
> 
> On Wed, Feb 6, 2013 at 4:53 PM, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
>> This patch adds rtc driver for Maxim 8997 multifunction chip.
>> Max8997 has rtc module in it. and it can be used for timekeeping
>> clock and system alarm. It provide various operational mode those are
>> BCD/binary, 24/12hour, am/pm. Driver sets binary/24/ for default.
>> Maxim 8997 also supports SMPL(Sudden Momentary Power Loss), WTSR
>> (Watchdog Timeout and Software Reset).
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> ---
>>  drivers/rtc/Kconfig       |   30 +++
>>  drivers/rtc/Makefile      |    1 +
>>  drivers/rtc/rtc-max8997.c |  542 +++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 573 insertions(+)
>>  create mode 100644 drivers/rtc/rtc-max8997.c
>>
>> +
>> +static int max8997_rtc_probe(struct platform_device *pdev)
>> +{
>> +       struct max8997_dev *max8997 = dev_get_drvdata(pdev->dev.parent);
>> +       struct max8997_rtc_info *info;
>> +       int ret, virq;
>> +
>> +       info = devm_kzalloc(&pdev->dev, sizeof(struct max8997_rtc_info),
>> +                       GFP_KERNEL);
>> +       if (!info)
>> +               return -ENOMEM;
>> +
>> +       mutex_init(&info->lock);
>> +       info->dev = &pdev->dev;
>> +       info->max8997 = max8997;
>> +       info->rtc = max8997->rtc;
>> +
>> +       platform_set_drvdata(pdev, info);
>> +
>> +       ret = max8997_rtc_init_reg(info);
>> +
>> +       if (ret < 0) {
>> +               dev_err(&pdev->dev, "Failed to initialize RTC reg:%d\n", ret);
>> +               return ret;
>> +       }
>> +
>> +       max8997_rtc_enable_wtsr(info, true);
>> +       max8997_rtc_enable_smpl(info, true);
>> +
>> +       device_init_wakeup(&pdev->dev, 1);
>> +
>> +       info->rtc_dev = rtc_device_register("max8997-rtc", &pdev->dev,
>> +                       &max8997_rtc_ops, THIS_MODULE);
>> +
>> +       if (IS_ERR(info->rtc_dev)) {
>> +               ret = PTR_ERR(info->rtc_dev);
>> +               dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
>> +               return ret;
>> +       }
>> +
>> +       virq = irq_create_mapping(max8997->irq_domain, MAX8997_PMICIRQ_RTCA1);
>> +       if (!virq) {
>> +               dev_err(&pdev->dev, "Failed to create mapping alarm IRQ\n");
>    +               rtc_device_unregister(&pdev->dev, &max8997_rtc_ops) ?

Yes, It should be,,

>> +               return ret;
>> +       }
>> +       info->virq = virq;
>> +
>> +       ret = request_threaded_irq(virq, NULL, max8997_rtc_alarm_irq, 0,
>> +                               "rtc-alarm0", info);
>> +       if (ret < 0) {
>> +               dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
>> +                       info->virq, ret);
>    +               here unregistering the rtc dev too?

also

>> +               return ret;
>> +       }
>> +
>> +       return ret;
>> +}
>> +
> 

Thanks for reviewing, I'll fix it.

Thanks,
Jonghwa

> 
> Thanks,
> 
