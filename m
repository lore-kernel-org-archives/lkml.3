Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab3FZVAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:00:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:3982 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab3FZVAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:00:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,946,1363158000"; 
   d="scan'208";a="356265112"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: RE: [PATCH] x86/mce: Update MCE severity condition check
Thread-Topic: [PATCH] x86/mce: Update MCE severity condition check
Thread-Index: AQHObZf4dVtHLM6ankO4NgcMDQSyUJlGddGAgAAxdHCAAY8IAIAAL7UbgAASlMCAAHtKgP//jmxA
Date: Wed, 26 Jun 2013 21:00:10 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31C56603@ORSMSX106.amr.corp.intel.com>
References: <20130626091808.GA18468@gchen.bj.intel.com>
 <0134840@agluck-desk.sc.intel.com> <20130626190845.GK20274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31C5653E@ORSMSX106.amr.corp.intel.com>
 <20130626203639.GM20274@pd.tnic>
In-Reply-To: <20130626203639.GM20274@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5QL0RVh009492

> And this obviously is the case for the hardware too, I assume, not only
> the SDM?

Yes - we have a magic process which reconfigures all deployed silicon whenever
a new SDM is published :-)

Actually the SDM had been collecting new features for each generation ... each
time just bolting on a new paragraph or table.  I snapped when I saw the table
that was proposed for 15-20 to add "continuable" errors and complained that
it had gotten way too complicated ... and proposed the version that you see in
the current SDM.

It accurately portrays what older generations implemented, and adds the new
continuable (EIPV=1, RIPV=1) while removing many rows and columns.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
