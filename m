Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaDNBgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:36:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34462 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbaDNBgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:36:54 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Sun, 13 Apr 2014 18:36:16 -0700
Subject: RE: [PATCH] ARM: perf: save/restore pmu registers in pm notifier
Thread-Topic: [PATCH] ARM: perf: save/restore pmu registers in pm notifier
Thread-Index: Ac9VtEyuaS1e8QzLSPW8oUg8q1Ca3QBzYrdQ
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE55075F139F@SC-VEXCH4.marvell.com>
References: <1397214083-30916-1-git-send-email-zhangwm@marvell.com>
 <53483511.4000100@codeaurora.org>
In-Reply-To: <53483511.4000100@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-12_01:2014-04-11,2014-04-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404140028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3E1b1Si013664

Stephen,

> -----Original Message-----
> From: Stephen Boyd [mailto:sboyd@codeaurora.org]
> Sent: 2014Äê4ÔÂ12ÈÕ 2:32
> To: Neil Zhang
> Cc: will.deacon@arm.com; linux@arm.linux.org.uk; Sudeep KarkadaNagesha;
> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] ARM: perf: save/restore pmu registers in pm notifier
> 
> On 04/11/14 04:01, Neil Zhang wrote:
> > @@ -217,6 +219,24 @@ static struct notifier_block
> cpu_pmu_hotplug_notifier = {
> >  	.notifier_call = cpu_pmu_notify,
> >  };
> >
> > +static int cpu_pmu_pm_notify(struct notifier_block *b,
> > +					unsigned long action, void *hcpu) {
> > +	int cpu = smp_processor_id();
> > +	struct cpupmu_regs *pmuregs = &per_cpu(cpu_pmu_regs, cpu);
> 
> this_cpu_ptr(&cpu_pmu_regs)?

Thanks for the suggestion, I will update it.

> 
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted
> by The Linux Foundation


Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
