Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab3GLQTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 12:19:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:4479 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823Ab3GLQT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 12:19:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,654,1367996400"; 
   d="scan'208";a="369337422"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Borislav Petkov <bp@alien8.de>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ming Lei <tom.leiming@gmail.com>, Linda Walsh <lkml@tlinx.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: RE: BUG: key ffff880c1148c478 not in .data! (V3.10.0)
Thread-Topic: BUG: key ffff880c1148c478 not in .data! (V3.10.0)
Thread-Index: AQHOfxrdPLmL8JP980CYV5tH00P+dJlhOAEQ
Date: Fri, 12 Jul 2013 16:19:24 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31C7D83C@ORSMSX106.amr.corp.intel.com>
References: <51D9EAF3.4050804@tlinx.org>
	<CACVXFVPRwakzB6vtqRqL49StHKdugCpxDyNvx3VzcDC7GggFMQ@mail.gmail.com>
	<20130712080428.GB359@x4>	<20130712134115.GI24008@pd.tnic>
	<51E00B55.5070003@infradead.org>	<20130712142106.GJ24008@pd.tnic>
 <20130712131340.1a371662.mchehab@infradead.org>
In-Reply-To: <20130712131340.1a371662.mchehab@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What would be a reasonable maximum limit for the number of memory
> controllers, on a -EX machine?

Westmere-EX has one memory controller per socket ... and there are glueless systems up to 8 sockets.  So 8 there. Not sure if any OEM is building larger machines with a node controller (SGI? Not sure if they build their behemoths from -EP or -EX parts).

Ivy Bridge ups the ante with two memory controllers on a socket. So plan on doubling soon.

-Tony
