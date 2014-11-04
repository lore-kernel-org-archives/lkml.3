Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaKDQ1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:27:50 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:9887 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbaKDQ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:27:42 -0500
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Boaz Harrosh <boaz@plexistor.com>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@kernel.dk>,
        "Kani, Toshimitsu" <toshi.kani@hp.com>,
        "Knippers, Linda" <linda.knippers@hp.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: RE: [PATCH 1/4] pmem: Initial version of persistent memory driver
Thread-Topic: [PATCH 1/4] pmem: Initial version of persistent memory driver
Thread-Index: AQHPwju+CJyN7gLloE2kV10Saf5ghpxNAAewgAJw1ICAAUFlgIAAYEuQ
Date: Tue, 4 Nov 2014 16:26:32 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295936C4B1@G4W3202.americas.hpqcorp.net>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
 <1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
 <94D0CD8314A33A4D9D801C0FE68B4029593548AB@G9W0745.americas.hpqcorp.net>
 <100D68C7BA14664A8938383216E40DE04082985D@FMSMSX114.amr.corp.intel.com>
 <5458AC75.3030207@plexistor.com>
In-Reply-To: <5458AC75.3030207@plexistor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA4GRrA2018753



> -----Original Message-----
> From: Boaz Harrosh [mailto:boaz@plexistor.com]
> Sent: Tuesday, 04 November, 2014 4:38 AM
> To: Wilcox, Matthew R; Elliott, Robert (Server Storage); Ross
> Zwisler; Jens Axboe; Nick Piggin; Kani, Toshimitsu; Knippers, Linda;
> linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> nvdimm@lists.01.org; Matthew Wilcox
> Subject: Re: [PATCH 1/4] pmem: Initial version of persistent memory
> driver
> 
> On 11/03/2014 06:19 PM, Wilcox, Matthew R wrote:
...
> 
> I wish you guys would actually review the correct code.
> 
> In the actual good driver that has any shape of proper code all these
> issue are gone.
> 
> * config defaults gone, multiple-devices multiple-memory ranges fully
>    supported hot plug style.
> * above shifts cruft completely gone it is left overs from brd.c and
>   its page usage.
> * getgeo fixed to do what we realy want by the only application on earth
>   that still uses it, fdisk. All other partitioners do not call it at
>   all.
> 
> Why are we reviewing dead code ?
> 
> Cheers
> Boaz

Ross, what's the status of Boaz' patches (available in
git://git.open-osd.org/pmem.git)?

https://github.com/01org/prd.git doesn't include any of 
them yet.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
