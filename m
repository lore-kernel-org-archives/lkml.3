Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966129AbaFTJCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:02:55 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43269 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858AbaFTJCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:02:53 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Will Deacon <will.deacon@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 20 Jun 2014 02:02:26 -0700
Subject: RE: [PATCH] arm64: add the ability to hook the fault code
Thread-Topic: [PATCH] arm64: add the ability to hook the fault code
Thread-Index: Ac+MY0LsrVpmFrh6RTmZ0+jh05CDpwAAw+XA
Message-ID: <9034CBD80F070943B59700D7F8149ED90182148D14@SC-VEXCH4.marvell.com>
References: <1403175296-25181-1-git-send-email-zhangwm@marvell.com>
 <20140620082556.GD25104@arm.com>
 <9034CBD80F070943B59700D7F8149ED90182148D02@SC-VEXCH4.marvell.com>
 <20140620083946.GF25104@arm.com>
In-Reply-To: <20140620083946.GF25104@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-20_03:2014-06-20,2014-06-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406200103
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5K930O3032305


> -----Original Message-----
> From: Will Deacon [mailto:will.deacon@arm.com]
> Sent: 2014å¹´6æœˆ20æ—¥ 16:40
> To: Neil Zhang
> Cc: Catalin Marinas; linux-kernel@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] arm64: add the ability to hook the fault code
> 
> On Fri, Jun 20, 2014 at 09:33:59AM +0100, Neil Zhang wrote:
> >
> > > -----Original Message-----
> > > From: Will Deacon [mailto:will.deacon@arm.com]
> > > Sent: 2014å¹´6æœˆ20æ—¥ 16:26
> > > To: Neil Zhang
> > > Cc: Catalin Marinas; linux-arm-kernel@lists.infradead.org;
> > > linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH] arm64: add the ability to hook the fault code
> > >
> > > On Thu, Jun 19, 2014 at 11:54:56AM +0100, Neil Zhang wrote:
> > > > Add the ability to hook the fault code for future use.
> > >
> > > Do you have a user for this in the kernel tree? I'd rather add the
> > > hook with the first user, if it doesn't exist already.
> > >
> >
> > Marvell Soc has a feature to use the external abort.
> > I didn't submit it since it's a private feature.
> 
> In which case, let's wait until we have a user of this in the mainline tree.
> 

OKï¼

> Will

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
