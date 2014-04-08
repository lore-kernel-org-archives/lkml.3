Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbaDHORM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:17:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:38842 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905AbaDHORH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:17:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,818,1389772800"; 
   d="scan'208";a="489264666"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: "tlinder@codeaurora.org" <tlinder@codeaurora.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [RFC/PATCH] mtd: ubi: Free peb's synchronously for fastmap
Thread-Topic: [RFC/PATCH] mtd: ubi: Free peb's synchronously for fastmap
Thread-Index: AQHPUzCady/abTx7YEyBZe1XnjSKHw==
Date: Tue, 8 Apr 2014 13:44:03 +0000
Message-ID: <1396964636.26672.66.camel@sauron.fi.intel.com>
References: <1396339305-16005-1-git-send-email-tlinder@codeaurora.org>
	 <1396964546.26672.65.camel@sauron.fi.intel.com>
In-Reply-To: <1396964546.26672.65.camel@sauron.fi.intel.com>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.82]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7538EFFA76C9D744B79443A819ABE6BA@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s38EHKbJ011144

On Tue, 2014-04-08 at 16:42 +0300, Artem Bityutskiy wrote:
> On Tue, 2014-04-01 at 11:01 +0300, Tanya Brokhman wrote:
> > At first mount it's possible that there are not enough free PEBs since
> > there are PEB's pending to be erased. In such scenario, fm_pool (which is
> > the pool from which user required PEBs are allocated) will be empty.
> > Try fixing the above described situation by synchronously performing
> > pending erase work, thus produce another free PEB.
> > 
> > Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> 
> Pushed to linux-ubifs.git / master, thanks!

Oh, sorry, this one I actually _dropped_. Would you please rather
re-structure the code to avoid duplication. E.g., do what Richard
suggested.

-- 
Best Regards,
Artem Bityutskiy
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
