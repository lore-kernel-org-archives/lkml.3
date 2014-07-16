Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaGPX25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:28:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:8597 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaGPX2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:28:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,674,1400050800"; 
   d="scan'208";a="544475153"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "'Ingo Molnar'" <mingo@kernel.org>
CC: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH v2 0/3] Clean up ACPI core to prepare for running ACPI
 on ARM64
Thread-Topic: [PATCH v2 0/3] Clean up ACPI core to prepare for running ACPI
 on ARM64
Thread-Index: AQHPm1mt6PJaNcb1gUqSyusXQh/kYpuj2waA//+JdoA=
Date: Wed, 16 Jul 2014 23:28:52 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3285FA2B@ORSMSX114.amr.corp.intel.com>
References: <1404898746-6685-1-git-send-email-hanjun.guo@linaro.org>
 <2351210.nfpIXXiZXh@vostro.rjw.lan>
In-Reply-To: <2351210.nfpIXXiZXh@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6GNT1Mb000398

> Are there any objections against this series from the x86 and ia64 maintainers?

I'll believe the claim of no functional changes for ia64 ... so no objections from me.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
