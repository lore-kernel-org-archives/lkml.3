Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaGOP5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:57:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:63273 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbaGOP5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:57:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,666,1400050800"; 
   d="scan'208";a="570165672"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>
Subject: RE: linux-next: manual merge of the char-misc tree with the ia64
 tree
Thread-Topic: linux-next: manual merge of the char-misc tree with the ia64
 tree
Thread-Index: AQHPn/gvsxmNCQtUYEGpiX/mNhK7IZuhm1cAgAABOAD//6NHIIAAepaA//+PFiA=
Date: Tue, 15 Jul 2014 15:57:42 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3285D02E@ORSMSX114.amr.corp.intel.com>
References: <20140715164349.5807b892@canb.auug.org.au>
 <20140715134458.GB17795@kroah.com> <20140715134920.GC17795@kroah.com>
 <3908561D78D1C84285E8C5FCA982C28F3285CF7A@ORSMSX114.amr.corp.intel.com>
 <20140715153613.GA4775@pd.tnic>
In-Reply-To: <20140715153613.GA4775@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6FFvp3S015966

> Currently, all the stuff we're doing is x86-only so arch/x86/ras/ might
> be a good place too, if other arches wanna do their own thing or if x86
> RAS facilities turn out to be PITA to make arch-independent.

Oops - not quite.  We moved creation of the EDAC trace point into drivers/ras/ras.c
and edac is not x86 specific.

We also create the PCIe AER tracepoint there too - PCIe is not x86 specific.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
