Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaA0J0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:26:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:41255 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbaA0J0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:26:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,728,1384329600"; 
   d="scan'208";a="471306592"
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
To: Jose Alonso <joalonsof@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Patelczyk, Maciej" <maciej.patelczyk@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] for_each macros correctness
Thread-Topic: [PATCH] for_each macros correctness
Thread-Index: AQHPGoT7e7SrNIkTEES4xIkxtgFybpqYTqkg
Date: Mon, 27 Jan 2014 09:26:45 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A6BEBEC@IRSMSX105.ger.corp.intel.com>
References: <1390733658.3059.10.camel@laptop>
In-Reply-To: <1390733658.3059.10.camel@laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0R9QxLf007776

On Sunday, January 26, 2014 11:54 AM Jose Alonso <joalonsof@gmail.com> wrote:
> I observed that there are for_each macros that do an extra memory access
> beyond the defined area.
> Normally this does not cause problems.
> But, this can cause exceptions. For example: if the area is allocated at
> the end of a page and the next page is not accessible.
> 
> For correctness, I suggest changing the arguments of the 'for loop' like
> others 'for_each' do in the kernel.
> 
> files involved:
>    drivers/s390/cio/qdio.h
>    drivers/scsi/isci/host.h

Hi Jose,

The macro in "drivers/scsi/isci/host.h" has already been corrected:
http://marc.info/?l=linux-kernel&m=139030404415970&w=2
So you can remove the part regarding "drivers/scsi/isci/host.h" from your patch.

Lukasz

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
