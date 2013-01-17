Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3AQRVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:21:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:27616 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3AQRVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:21:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,486,1355126400"; 
   d="scan'208";a="192293910"
From: "Luck, Tony" <tony.luck@intel.com>
To: Lance Ortiz <lance.ortiz@hp.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v10 3/3] aerdrv: Cleanup log output for AER
Thread-Topic: [PATCH v10 3/3] aerdrv: Cleanup log output for AER
Thread-Index: AQHN9DzTsAAIqEuZ8k+pCRGSwN7eb5hNxM7w
Date: Thu, 17 Jan 2013 17:21:26 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C986E72@ORSMSX108.amr.corp.intel.com>
References: <20130116235102.16015.77379.stgit@grignak.americas.hpqcorp.net>
 <20130116235116.16015.62519.stgit@grignak.americas.hpqcorp.net>
In-Reply-To: <20130116235116.16015.62519.stgit@grignak.americas.hpqcorp.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0HHLVsm030940

> These changes make cper_print_aer more consistent with aer_print_error
> and clean things up by eliminating the use of the prefix variable and
> replacing it with dev_printk.

Applied v10 series and put it into my "next" branch so linux-next will
grab it on the next cycle.  Will try to interest the "tip" maintainers in
pulling again in a few days.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
