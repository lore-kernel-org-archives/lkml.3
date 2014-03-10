Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaCJJPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:15:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:36905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbaCJJP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:15:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,622,1389772800"; 
   d="scan'208";a="469471756"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux-SH <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
Subject: Re: [PATCH v3] shdma: add R-Car Audio DMAC peri peri driver
Thread-Topic: [PATCH v3] shdma: add R-Car Audio DMAC peri peri driver
Thread-Index: AQHPPEFDQGkUKyxi6EWe3V1zBstuWw==
Date: Mon, 10 Mar 2014 09:15:21 +0000
Message-ID: <1394442921.28803.208.camel@smile.fi.intel.com>
References: <878uu6gle8.wl%kuninori.morimoto.gx@gmail.com>
	 <87wqg2rdqk.wl%kuninori.morimoto.gx@gmail.com>
In-Reply-To: <87wqg2rdqk.wl%kuninori.morimoto.gx@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="utf-8"
Content-ID: <34E3AE8D4DC34D4CBC3F4B074CB21E5D@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2A9Fn2B015493

On Sun, 2014-03-09 at 19:25 -0700, Kuninori Morimoto wrote:
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> Add support Audio DMAC peri peri driver
> for Renesas R-Car Gen2 SoC, using 'shdma-base'
> DMA driver framework.
> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> ---
> v2 -> v3

My previous mail is applicable to this version too.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
