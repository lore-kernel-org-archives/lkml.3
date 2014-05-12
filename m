Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaELKWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 06:22:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48930 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbaELKWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 06:22:46 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: "'Sudeep Holla'" <sudeep.holla@arm.com>,
        "'Will Deacon'" <Will.Deacon@arm.com>
CC: "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devicetree@vger.kernel.org'" <devicetree@vger.kernel.org>,
        Neil Zhang <zhangwm@marvell.com>
Date: Mon, 12 May 2014 03:22:09 -0700
Subject: RE: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Thread-Topic: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Thread-Index: Ac9keD1np1G9qntpQoC2LI657voXkgDliarQAW9ShSA=
Message-ID: <9034CBD80F070943B59700D7F8149ED9A0875730@SC-VEXCH4.marvell.com>
References: <1398133596-29170-1-git-send-email-zhangwm@marvell.com>
 <20140422103642.GF7484@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE5507A3B59B@SC-VEXCH4.marvell.com>
 <20140423170821.GJ5649@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE5507A3C1F1@SC-VEXCH4.marvell.com>
 <5360FB07.5030407@arm.com>
 <6106CAF835F351419ADA79E4836E6EC71B6A53C826@SC-VEXCH4.marvell.com>
In-Reply-To: <6106CAF835F351419ADA79E4836E6EC71B6A53C826@SC-VEXCH4.marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-12_01:2014-05-12,2014-05-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1405120140
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4CAMqoH018895

Will & Sudeep,

> -----Original Message-----
> From: Neil Zhang
> Sent: 2014å¹´5æœˆ5æ—¥ 14:28
> To: Sudeep Holla; Will Deacon
> Cc: linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; devicetree@vger.kernel.org
> Subject: RE: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
> 
> Sudeep,
> 
> > -----Original Message-----
> > From: Sudeep Holla [mailto:sudeep.holla@arm.com]
> > Sent: 2014å¹´4æœˆ30æ—¥ 21:31
> > To: Neil Zhang; Will Deacon
> > Cc: Sudeep Holla; linux@arm.linux.org.uk;
> > linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> > devicetree@vger.kernel.org
> > Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm
> > notifier
> >
> > Hi Neil,
> >
> > On 30/04/14 03:21, Neil Zhang wrote:
> > >
> > >> -----Original Message-----
> > >> From: Will Deacon [mailto:will.deacon@arm.com]
> >
> > [...]
> >
> > >>
> > >> I think we need some input from the device-tree guys to see whether
> > >> they would object to us solving this locally (in the PMU node) or not.
> > >> Personally, I'd much prefer a general way to describe the need for
> > >> pm-notifiers, but if that's not being looked at then we can cook
> > >> something specifically for our needs.
> > >>
> > >
> > > No input from device-tree guys :(
> >
> > The device tree bindings for power domains is under discussion [1]
> 
> Thanks for the information.
> But it currently for device only, core related stuff are not supported.
> And is it really good to register power provider for core and let vfp / pmu etc
> to get it?
> 

What's your suggestion about it?
Is it OK that I add it under the PMU node?

> >
> > Regards,
> > Sudeep
> >
> > [1] https://lkml.org/lkml/2014/4/23/755
> 
> 
> Best Regards,
> Neil Zhang

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
