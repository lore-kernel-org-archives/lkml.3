Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaJMP3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:29:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:55982 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaJMP3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:29:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,711,1406617200"; 
   d="scan'208";a="613690645"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: "richard@nod.at" <richard@nod.at>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
Thread-Topic: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
Thread-Index: AQHP5vpfsFd7T6dHm0SiA+ARqaaDeA==
Date: Mon, 13 Oct 2014 15:28:43 +0000
Message-ID: <1413214122.7906.46.camel@sauron.fi.intel.com>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
	 <1412029248-22454-4-git-send-email-richard@nod.at>
	 <1412346676.3795.62.camel@sauron.fi.intel.com> <542EF3BF.1070401@nod.at>
	 <1413206263.7906.18.camel@sauron.fi.intel.com> <543BE21F.5020504@nod.at>
	 <1413213803.7906.45.camel@sauron.fi.intel.com>
In-Reply-To: <1413213803.7906.45.camel@sauron.fi.intel.com>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.162]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A33A3DAC44650F4A8C5E3B267893F36B@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9DFTIns020596

On Mon, 2014-10-13 at 18:23 +0300, Artem Bityutskiy wrote:
> > The interface would work but some work in wl.c is needed.
> > For example if I want to find out in which state PEB 1 is wl.c would have to
> > look int free free, used free, protection queue, etc.. to tell me the state. This is slow.
> 
> Well, used and free are RB-trees, looking them up is slow.

I wanted to say "not slow" here, sorry.

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
