Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaDNCG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 22:06:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:18905 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbaDNCG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 22:06:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,853,1389772800"; 
   d="scan'208";a="492341814"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] pwm_lpss: Add support for PCI devices
Thread-Topic: [PATCH] pwm_lpss: Add support for PCI devices
Thread-Index: AQHPVhP1bci2OBKO+kqYMQwhKouSaZsO1QwAgAGJ3AA=
Date: Mon, 14 Apr 2014 02:05:25 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA01570A7A@PGSMSX103.gar.corp.intel.com>
References: <1397311131-13371-1-git-send-email-chiau.ee.chew@intel.com>
 <534A67B8.80600@linux.intel.com>
In-Reply-To: <534A67B8.80600@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3E26c6d013848

> >  MODULE_DESCRIPTION("PWM driver for Intel LPSS");
> >MODULE_AUTHOR("Mika
> > Westerberg <mika.westerberg@linux.intel.com>");
> >  MODULE_LICENSE("GPL v2");
> >  MODULE_ALIAS("platform:pwm-lpss");
> 
> Looks a good idea to combine pci and acpi driver together.
> Since pci driver is added, here the alias need to be refined.
> Others look good.
> 
> Thanks,
> -Aubrey

Ok. I will change it to MODULE_ALIAS("pci/platform:pwm-lpss");

Thanks,
Chiau Ee


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
