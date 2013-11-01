Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3KAU6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 16:58:08 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:57977 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3KAU6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 16:58:06 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Richard Weinberger <richard@nod.at>
CC: Tony Luck <tony.luck@gmail.com>, Madper Xie <cxie@redhat.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        =?gb2312?B?0Luzyb+l?= <bbboson@gmail.com>
Subject: RE: [PATCH] Make efi-pstore return a unique id
Thread-Topic: [PATCH] Make efi-pstore return a unique id
Thread-Index: AQHO1x11Ng/G6VnJcECFaGjfqkQ0X5oQ08KAgAApt4D//8FFUIAAUlQA///ElKA=
Date: Fri, 1 Nov 2013 20:57:34 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DDA4D@USINDEM103.corp.hds.com>
References: <87ppqk6qvx.fsf@redhat.com>
 <CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com>
 <CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com>
 <52740A3A.70202@nod.at>
In-Reply-To: <52740A3A.70202@nod.at>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-01_05:2013-11-01,2013-11-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311010179
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA1KwCvk002155

> What about feeding the bytes of all three integers into a non-cryptographic hash function?
> Using this way you get a cheap unique id.

It is reasonable to me.

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
