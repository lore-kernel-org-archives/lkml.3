Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaE1RWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:22:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:27362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbaE1RWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:22:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,929,1392192000"; 
   d="scan'208";a="519159880"
From: "Luck, Tony" <tony.luck@intel.com>
To: "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        Chen Yucong <slaoub@gmail.com>
CC: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: RE: [RFC PATCH 0/3] RAS: Correctable Errors Collector thing
Thread-Topic: [RFC PATCH 0/3] RAS: Correctable Errors Collector thing
Thread-Index: AQHPea9uzw0xsNMixkSji90xyCLmY5tVwNSAgADr4ID//5Gj4A==
Date: Wed, 28 May 2014 17:21:57 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3282054D@ORSMSX114.amr.corp.intel.com>
References: <1401197235-13440-1-git-send-email-bp@alien8.de>
	 <1401245361.5049.6.camel@cyc>
 <1401296015.4361.12.camel@oc3432500282.ibm.com>
In-Reply-To: <1401296015.4361.12.camel@oc3432500282.ibm.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4SHMPpb000397

> A possible alternative would be to soft-offline the page. This is
> currently done in APEI code when corrected memory error thresholds are
> exceeded and reported by UEFI via a generic hardware error source
> (GHES). 

+1

This is what the existing mcelog(8) daemon does when it sees an excessive
number of corrected errors on a page (using /sys/devices/system/memory/soft_offline_page
as the user->kernel interface to get to this function).

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
