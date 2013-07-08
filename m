Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab3GHU0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:26:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:5378 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab3GHU0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:26:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1022,1363158000"; 
   d="scan'208";a="367046970"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>
CC: "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: RE: [PATCH 4] mce: acpi/apei: Add a sysctl to control page
 offlining on firmware report
Thread-Topic: [PATCH 4] mce: acpi/apei: Add a sysctl to control page
 offlining on firmware report
Thread-Index: AQHOdyOOINHwbMl7RU6Wh8zeSIvWm5lTf1QAgAAQsQCAB7OcAA==
Date: Mon, 8 Jul 2013 20:26:12 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31C76B19@ORSMSX106.amr.corp.intel.com>
References: <20130701153728.6197.14022.stgit@localhost.localdomain>
 <20130702125137.7388.97225.stgit@localhost.localdomain>
 <20130703144641.GC13951@pd.tnic> <51D44752.3000303@linux.vnet.ibm.com>
In-Reply-To: <51D44752.3000303@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r68KQNQU006836

> Nope, this is a just-in-case thing. I think you or Tony asked to have 
> this in a previous discussion so that we're covered if firmware starts 
> acting up. Other than that, I'm ok if this is left out.

I'm struggling to think of a case where this would help.  It implies that
we are on a running system, and we somehow notice that the BIOS is
telling us to take some pages offline - and that we know better than the
BIOS that we'd like to just ignore any more such messages from the BIOS.

But we still leave the BIOS in charge of logging the errors and keeping
track of the thresholds.

I'm happy with just the acpi=nocmcff to avoid a BIOS that does weird
stuff.  Or do you think we might still have to deal with a string of APEI
messages?

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
