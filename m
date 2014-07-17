Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbaGQQ61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:58:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:18729 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbaGQQ6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:58:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,679,1400050800"; 
   d="scan'208";a="563309985"
From: "Luck, Tony" <tony.luck@intel.com>
To: Hanjun Guo <hanjun.guo@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: RE: [PATCH v2 1/3] ACPI: ARM64 does not have a BIOS add config for
 BIOS table scan.
Thread-Topic: [PATCH v2 1/3] ACPI: ARM64 does not have a BIOS add config for
 BIOS table scan.
Thread-Index: AQHPm1m1j/+tKuv29U+nXg3qheEooZuj3IwA//+MwHCAAHZvAIAAOl4AgABvk/A=
Date: Thu, 17 Jul 2014 16:58:18 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32866139@ORSMSX113.amr.corp.intel.com>
References: <1404898746-6685-1-git-send-email-hanjun.guo@linaro.org>
 <1404898746-6685-2-git-send-email-hanjun.guo@linaro.org>
 <53C70CCC.2080109@zytor.com>
 <3908561D78D1C84285E8C5FCA982C28F3285FB3C@ORSMSX114.amr.corp.intel.com>
 <53C70F78.40206@zytor.com> <53C7406E.40902@linaro.org>
In-Reply-To: <53C7406E.40902@linaro.org>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6HGwXoS007037

> Tony, if it is ok with you, I will modify the patch and will not select
> ACPI_LEGACY_TABLES_LOOKUP on IA64, I'm waiting for your final confirmation.

Confirmed.  Thanks Peter for catching this.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
