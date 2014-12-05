Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaLEKWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:22:42 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:5655 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860AbaLEKWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:22:41 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Konstantin Khlebnikov'" <koct9i@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>
Date: Fri, 5 Dec 2014 18:22:33 +0800
Subject: RE: [RFC] mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
Thread-Topic: [RFC] mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
Thread-Index: AdAQbL4wpUfFy3dLT6mpetrVRyoPkgACJgwg
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313F2@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
 <CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com>
In-Reply-To: <CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB5EEGZk011815

> -----Original Message-----
> From: Konstantin Khlebnikov [mailto:koct9i@gmail.com]
> Sent: Friday, December 05, 2014 5:21 PM
> To: Wang, Yalin
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org; linux-arm-
> kernel@lists.infradead.org; akpm@linux-foundation.org; n-
> horiguchi@ah.jp.nec.com
> Subject: Re: [RFC] mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
> 
> On Fri, Dec 5, 2014 at 11:57 AM, Wang, Yalin <Yalin.Wang@sonymobile.com>
> wrote:
> > This patch add KPF_ZERO_PAGE flag for zero_page, so that userspace
> > process can notice zero_page from /proc/kpageflags, and then do memory
> > analysis more accurately.
> 
> It would be nice to mark also huge_zero_page. See (completely
> untested) patch in attachment.
> 
Got it,
Thanks for your patch.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
