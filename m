Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3FNSCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 14:02:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:34623 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933Ab3FNSB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 14:01:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,867,1363158000"; 
   d="scan'208";a="329594826"
From: "Luck, Tony" <tony.luck@intel.com>
To: Toshi Kani <toshi.kani@hp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Lu, Aaron" <aaron.lu@intel.com>
Subject: RE: [PATCH 0/5] ACPI / scan: Make it possible to use the container
 hotplug with other scan handlers
Thread-Topic: [PATCH 0/5] ACPI / scan: Make it possible to use the container
 hotplug with other scan handlers
Thread-Index: AQHOZ8NExC336lwoYkuVyt/gdZt4kZk0n9qAgAAMUwCAAAMFAIAA0sCQ
Date: Fri, 14 Jun 2013 18:01:41 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA7C18E@ORSMSX106.amr.corp.intel.com>
References: <1417592.vuSG0cUIGo@vostro.rjw.lan>
	 <1371158939.21540.39.camel@misato.fc.hp.com>
	 <1461809.TyKCjmiDDv@vostro.rjw.lan>
 <1371162234.21540.43.camel@misato.fc.hp.com>
In-Reply-To: <1371162234.21540.43.camel@misato.fc.hp.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5EI28sW006966

>> Tony promised me to test those patches on his box, so we'll know for sure
>> in a while.

Tested this series - and the box boots just fine with no unexpected messages.

But I should note that this box doesn't have anything that is hot pluggable, so I
couldn't test hotplug (which seems to be deeply involved with things that this
patch is touching).

Of course that means that I haven't been testing hotplug - so it might have been
broken for years and I'd never have noticed.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
