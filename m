Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbaGDDFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 23:05:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38757 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbaGDDFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 23:05:49 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Neil Zhang <zhangwm@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>
Date: Thu, 3 Jul 2014 20:05:04 -0700
Subject: RE: [PATCH] ARM: remove redundant code in machine_halt
Thread-Topic: [PATCH] ARM: remove redundant code in machine_halt
Thread-Index: Ac9puD2RErQqFXJuQiy+8xOHck3BAQFkRysQCfrW63A=
Message-ID: <9034CBD80F070943B59700D7F8149ED90182308483@SC-VEXCH4.marvell.com>
References: <1399441823-9907-1-git-send-email-zhangwm@marvell.com>
 <9034CBD80F070943B59700D7F8149ED9A0875745@SC-VEXCH4.marvell.com>
In-Reply-To: <9034CBD80F070943B59700D7F8149ED9A0875745@SC-VEXCH4.marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-03_08:2014-07-03,2014-07-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1407040040
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s64364Ha013693

> -----Original Message-----
> From: Neil Zhang
> Sent: 2014Äê5ÔÂ14ÈÕ 15:52
> To: Neil Zhang; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org
> Cc: rmk+kernel@arm.linux.org.uk
> Subject: RE: [PATCH] ARM: remove redundant code in machine_halt
> 
> > -----Original Message-----
> > From: Neil Zhang [mailto:zhangwm@marvell.com]
> > Sent: 2014Äê5ÔÂ7ÈÕ 13:50
> > To: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > Cc: rmk+kernel@arm.linux.org.uk; Neil Zhang
> > Subject: [PATCH] ARM: remove redundant code in machine_halt
> >
> > There is no need to call local_irq_disable twice.
> >
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > ---
> >  arch/arm/kernel/process.c |    1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c index
> > 81ef686..18cfce4 100644
> > --- a/arch/arm/kernel/process.c
> > +++ b/arch/arm/kernel/process.c
> > @@ -195,7 +195,6 @@ void machine_halt(void)
> >  	local_irq_disable();
> >  	smp_send_stop();
> >
> > -	local_irq_disable();
> >  	while (1);
> >  }
> >
> > --
> > 1.7.9.5
> 
> Any comments?
> 

Ping!

> Best Regards,
> Neil Zhang

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
