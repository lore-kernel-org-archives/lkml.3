Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaCMPIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:08:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:48654 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016AbaCMPHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:07:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,647,1389772800"; 
   d="scan'208";a="497806832"
From: "Cox, Alan" <alan.cox@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] gpio / ACPI: Add support for ACPI GPIO operation
 regions
Thread-Topic: [PATCH v2 5/5] gpio / ACPI: Add support for ACPI GPIO
 operation regions
Thread-Index: AQHPPF/7FeJXHMM5fkiuNQGur8cpxJrfGT6AgAAJOQA=
Date: Thu, 13 Mar 2014 15:05:02 +0000
Message-ID: <1394723102.17925.40.camel@acox1-desk.ger.corp.intel.com>
References: <1394456094-21671-1-git-send-email-mika.westerberg@linux.intel.com>
	 <1394456094-21671-6-git-send-email-mika.westerberg@linux.intel.com>
	 <CACRpkdY3z-XGHwn5sQKM-8cKYHzr3_40h53032ETN6PaDW779w@mail.gmail.com>
In-Reply-To: <CACRpkdY3z-XGHwn5sQKM-8cKYHzr3_40h53032ETN6PaDW779w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.120.227]
Content-Type: text/plain; charset="utf-8"
Content-ID: <02D5CBBA8450B348AEA5B9D96D501EF4@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2DF8D4e010024

> > +                       gpiod_set_raw_value(desc, !!((1 << i) & *value));
> 
> What is this? How can the expression !!((1 << i) possibly evaluate to
> anything else than "true"? I don't get it. Just (desc, *value) seem more
> apropriate.


The expression is !!((1 << i) & *value)

so its the standard C sematic for 'logical and' ? 1 : 0


---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
