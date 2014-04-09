Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692AbaDIWpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 18:45:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:32517 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932804AbaDIWoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 18:44:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,829,1389772800"; 
   d="scan'208";a="490310797"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jason Baron <jbaron@akamai.com>
CC: Borislav Petkov <bp@alien8.de>, Aristeu Rozanski <aris@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] ie31200_edac: Add driver
Thread-Topic: [PATCH 3/3] ie31200_edac: Add driver
Thread-Index: AQHPUErabVWTFTq13UyiP3ii3SIN9psJpHwAgAAhKgD//8g+EIAAe16AgAAWkYCAAATpAIAACuCAgAAGRID//5pcUIAAhveA//+Q5mA=
Date: Wed, 9 Apr 2014 22:44:21 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31E237A2@ORSMSX106.amr.corp.intel.com>
References: <cover.1396645124.git.jbaron@akamai.com>
 <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com>
 <20140409113552.GJ6529@pd.tnic> <20140409133433.GJ29214@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F31E22EAC@ORSMSX106.amr.corp.intel.com>
 <20140409173633.GN6529@pd.tnic> <5345980F.7070604@akamai.com>
 <20140409191454.GQ6529@pd.tnic> <5345A54D.2050808@akamai.com>
 <20140409201615.GS6529@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31E2358F@ORSMSX106.amr.corp.intel.com>
 <5345C683.2080307@akamai.com>
In-Reply-To: <5345C683.2080307@akamai.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s39MjXf2022375

> So when the driver sees uncorrected errors, I'm also seeing them in my
> memory scanning program - so they correspond nicely. I didn't see anything
> logged in /var/log/mcelog, but I will update to the latest when possible.

I wonder if there are some BIOS options to enable reporting via CMCI/MCE?
On the E5 systems the reference BIOS uses phrases like "poison forwarding"
in the option names.

The above behavior sounds less than useful.

Scenario: Your mission critical app is running (controlling a giant laser cutter).
Oops there is a memory error, and the bad data arrives at the application causing
it to swing the laser beam through 180 degrees, destroying half of your lab.
A few seconds/minutes later - your EDAC driver prints a message saying that
the uncorrected error count just got incremented.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
