Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab3K0RXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 12:23:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:30486 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3K0RXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 12:23:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,783,1378882800"; 
   d="scan'208";a="441139474"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "freemangordon@abv.bg" <freemangordon@abv.bg>,
        "aaro.koskinen@iki.fi" <aaro.koskinen@iki.fi>,
        "pavel@ucw.cz" <pavel@ucw.cz>
Subject: RE: [PATCH v2 1/3] power_supply: Add power_supply notifier
Thread-Topic: [PATCH v2 1/3] power_supply: Add power_supply notifier
Thread-Index: AQHO5RFDfa/cA+i2sUmlOXctUUhQ1Zo5YDAA
Date: Wed, 27 Nov 2013 17:23:34 +0000
Message-ID: <20ADAB092842284E95860F279283C5640AAF43B1@BGSMSX104.gar.corp.intel.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-2-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1384856285-19593-2-git-send-email-pali.rohar@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rARHNmem022664


> Subject: [PATCH v2 1/3] power_supply: Add power_supply notifier
> 
> This patch adds a notifier chain to the power_supply.
> This notifier helps drivers in other subsystem to listen to changes in power supply
> subsystem. This would help to take some actions in those drivers on changing the power
> supply properties.
> One such scenario is to increase/decrease system performance based on the battery
> capacity/voltage. Another scenario is to adjust the h/w peak current detection
> voltage/current thresholds based on battery voltage/capacity. The notifier helps drivers to
> listen to changes in power_suppy susbystem without polling the power_supply properties
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> Signed-off-by: Pali RohÃ¡r <pali.rohar@gmail.com>
> ---

Acked-by: Jenny TC <jenny.tc@intel.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
