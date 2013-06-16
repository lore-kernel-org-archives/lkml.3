Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3FPALz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 20:11:55 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:42318 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3FPALx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 20:11:53 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Cliff Wickman <cpw@sgi.com>,
        Alex Shi <alex.shi@intel.com>, Sasha Levin <levinsasha928@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "bp@alien8.de" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: RE: [PATCH v15 0/4] trace,x86: irq vector tracepoint support
Thread-Topic: [PATCH v15 0/4] trace,x86: irq vector tracepoint support
Thread-Index: AQHOY8CekDHD2kZxTEi/xfe/vZV94pk1ZXaggAJDQYD//9tN8A==
Date: Sun, 16 Jun 2013 00:10:54 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41B03C330@USINDEM103.corp.hds.com>
References: <51B2472B.9040909@hds.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D41B03B6CC@USINDEM103.corp.hds.com>
 <51BCE8BF.5080008@zytor.com>
In-Reply-To: <51BCE8BF.5080008@zytor.com>
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
 definitions=2013-06-15_08:2013-06-14,2013-06-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1306150305
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5G0COGX013034

> 
> This patchset breaks building with SGI UV support enabled:
> 
> /home/hpa/kernel/distwork/arch/x86/platform/uv/tlb_uv.c: In function
> â€˜uv_bau_initâ€™:
> /home/hpa/kernel/distwork/arch/x86/platform/uv/tlb_uv.c:2130:1: error:
> â€˜trace_uv_bau_message_intr1â€™ undeclared (first
> use in this function)
> /home/hpa/kernel/distwork/arch/x86/platform/uv/tlb_uv.c:2130:1: note:
> each undeclared identifier is reported only once
>  for each function it appears in

I will fix it.

Thanks.

Seiji

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
