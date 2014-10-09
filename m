Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbaJIHZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:25:30 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:12029 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbaJIHZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:25:20 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Geert Uytterhoeven'" <geert@linux-m68k.org>
CC: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        DL-WW-ContributionOfficers-Linux 
	<DL-WW-ContributionOfficers-Linux@sonymobile.com>
Date: Thu, 9 Oct 2014 15:25:16 +0800
Subject: RE: [PATCH resend] arm:extend the reserved memory for initrd to be
 page aligned
Thread-Topic: [PATCH resend] arm:extend the reserved memory for initrd to be
 page aligned
Thread-Index: Ac/i7r0v2ASnuZlKQuKNdXJ9FB6zTQAowkNw
Message-ID: <35FD53F367049845BC99AC72306C23D103D6DB491642@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103D6DB49161F@CNBJMBX05.corpusers.net>
 <CAMuHMdUDxemAOsE1E1Ba3zjhtMSp-k=n4_YxRJ2k_C_kZdBr=Q@mail.gmail.com>
In-Reply-To: <CAMuHMdUDxemAOsE1E1Ba3zjhtMSp-k=n4_YxRJ2k_C_kZdBr=Q@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s997PYXe028937

> Who guarantees there's no valuable data in [start, initrd_start) and
> [initrd_end, end) being corrupted?
> 
mm..
I am not sure if the memblock_reserve will reserve
Memory from page aligned address?
If not, do we need also make memblock_reserve the initrd memory
>From page aligned start(round down) to page aligned end address(round up) ? 

Thanks
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
