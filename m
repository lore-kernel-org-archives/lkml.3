Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaJTJ05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:26:57 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15623 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115AbaJTJ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:26:55 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Will Deacon <will.deacon@arm.com>, Sudeep Holla <Sudeep.Holla@arm.com>
CC: "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devicetree@vger.kernel.org'" <devicetree@vger.kernel.org>,
        "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>
Date: Mon, 20 Oct 2014 02:26:19 -0700
Subject: RE: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Thread-Topic: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Thread-Index: Ac/sRxGWlxvQZfv1T4uoHXqj38lT6AAALQJQ
Message-ID: <9034CBD80F070943B59700D7F8149ED9024EB81CDD@SC-VEXCH4.marvell.com>
References: <6106CAF835F351419ADA79E4836E6EC71B6A53C826@SC-VEXCH4.marvell.com>
 <9034CBD80F070943B59700D7F8149ED9A0875730@SC-VEXCH4.marvell.com>
 <20140513184503.GF16388@arm.com>
 <9034CBD80F070943B59700D7F8149ED9A087573F@SC-VEXCH4.marvell.com>
 <537337F3.4080300@arm.com>
 <9034CBD80F070943B59700D7F8149ED9A0875776@SC-VEXCH4.marvell.com>
 <9034CBD80F070943B59700D7F8149ED90182308172@SC-VEXCH4.marvell.com>
 <20140703175706.GI17372@arm.com>
 <9034CBD80F070943B59700D7F8149ED9024EB81CD8@SC-VEXCH4.marvell.com>
 <5444D2E0.9070205@arm.com> <20141020092005.GD4370@arm.com>
In-Reply-To: <20141020092005.GD4370@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-20_01:2014-10-17,2014-10-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410200095
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9K9R7H6023394


> -----Original Message-----
> From: Will Deacon [mailto:will.deacon@arm.com]
> Sent: 2014Äê10ÔÂ20ÈÕ 17:20
> To: Sudeep Holla
> Cc: Neil Zhang; 'linux@arm.linux.org.uk'; 'linux-arm-
> kernel@lists.infradead.org'; 'linux-kernel@vger.kernel.org';
> 'devicetree@vger.kernel.org'; mathieu.poirier@linaro.org
> Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm
> notifier
> 
> On Mon, Oct 20, 2014 at 10:16:16AM +0100, Sudeep Holla wrote:
> > On 20/10/14 09:46, Neil Zhang wrote:
> > > Will, I prefer to check always-on field under PMU node to check
> > > whether we need Save/restore them.
> > >
> > But how do you handle it for different idle states. e.g. if CPU is in
> > retention, PMU's *might be* retained. Also I don't think PMUs will be
> > placed in "always-on" power domain like timers. So using "always-on"
> > sounds incorrect to me.
> 
> Adding Mathieu to CC, since I spoke to him at LPC about this and he was
> talking about implementing proper PM domain descriptions for coresight
> components.
> 

Good to know that!
Hope we can figure out it with a proper way.

> Will

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
