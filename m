Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324Ab3JPX1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 19:27:09 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:34678 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3JPX1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 19:27:07 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "fdeslaur@gmail.com" <fdeslaur@gmail.com>,
        "raphael.beamonte@gmail.com" <raphael.beamonte@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: RE: [PATCH v3] Introduce page fault tracepoint
Thread-Topic: [PATCH v3] Introduce page fault tracepoint
Thread-Index: AQHOrad/oNbddzIzgE+oLKBHsS+xvpn26/MAgAFEJ1A=
Date: Wed, 16 Oct 2013 23:25:54 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443EF85AD@USINDEM103.corp.hds.com>
References: <522E43D5.9010505@hds.com> <525DD612.6050409@zytor.com>
In-Reply-To: <525DD612.6050409@zytor.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-16_07:2013-10-17,2013-10-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310160112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9GNRY6b005609

Thank you for reviewing.

> >     http://marc.info/?l=linux-mm&m=136807959830182&w=2
> >     http://marc.info/?l=linux-mm&m=136807959130175&w=2
> >
> 
> For permanence, please use links of the form:
> 
> 	http://lkml.kernel.org/r/message-id
> 
> (Yes, they currently point to marc.info, but can be redirected to point
> to any archive.)

I will fix it.

> This is needlessly confusing, which is apart of why reviewing this patch
> took a lot more time than it should.
> 
> Please break this patch into two: one which sets up the tracing IDT and
> one to create the #PF tracepoint.  The assumption is, I am assuming,
> there will be more.

OK. I will divide the patch into two or more to make the review smooth.

Seiji

> 
> 	-hpa

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
