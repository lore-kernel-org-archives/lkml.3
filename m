Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaENC2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 22:28:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35880 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024AbaENC2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 22:28:39 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: Sudeep Holla <Sudeep.Holla@arm.com>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devicetree@vger.kernel.org'" <devicetree@vger.kernel.org>
Date: Tue, 13 May 2014 19:28:02 -0700
Subject: RE: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Thread-Topic: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Thread-Index: Ac9u24W9Lw/UazH9SOGhSwVZQJSzigAP/JXQ
Message-ID: <9034CBD80F070943B59700D7F8149ED9A087573F@SC-VEXCH4.marvell.com>
References: <1398133596-29170-1-git-send-email-zhangwm@marvell.com>
 <20140422103642.GF7484@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE5507A3B59B@SC-VEXCH4.marvell.com>
 <20140423170821.GJ5649@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE5507A3C1F1@SC-VEXCH4.marvell.com>
 <5360FB07.5030407@arm.com>
 <6106CAF835F351419ADA79E4836E6EC71B6A53C826@SC-VEXCH4.marvell.com>
 <9034CBD80F070943B59700D7F8149ED9A0875730@SC-VEXCH4.marvell.com>
 <20140513184503.GF16388@arm.com>
In-Reply-To: <20140513184503.GF16388@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-13_07:2014-05-13,2014-05-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1405140032
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4E2Sogi001578

> -----Original Message-----
> From: Will Deacon [mailto:will.deacon@arm.com]
> Sent: 2014Äê5ÔÂ14ÈÕ 2:45
> To: Neil Zhang
> Cc: Sudeep Holla; 'linux@arm.linux.org.uk';
> 'linux-arm-kernel@lists.infradead.org'; 'linux-kernel@vger.kernel.org';
> 'devicetree@vger.kernel.org'
> Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
> 
> On Mon, May 12, 2014 at 11:22:09AM +0100, Neil Zhang wrote:
> > > > The device tree bindings for power domains is under discussion [1]
> > >
> > > Thanks for the information.
> > > But it currently for device only, core related stuff are not supported.
> > > And is it really good to register power provider for core and let
> > > vfp / pmu etc to get it?
> > >
> >
> > What's your suggestion about it?
> > Is it OK that I add it under the PMU node?
> 
> I don't really mind. I just want to avoid re-inventing the wheel in a
> PMU-specific way and having to maintain that code forever because it ended
> up in our DT description.
> 
> Will

I will prepare another patch to add DT description under PMU since there is 
no generic power domain support for pm notifier if no other concerns.
We can change the manner if there is generic power domain support for pm notifier later.
Thanks.

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
