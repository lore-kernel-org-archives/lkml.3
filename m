Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3JKOyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:54:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:55269 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab3JKOyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:54:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1081,1371106800"; 
   d="scan'208";a="373492635"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, "Chen, Gong" <gong.chen@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: Extended H/W error log driver
Thread-Topic: Extended H/W error log driver
Thread-Index: AQHOxk27t0f2crDWuUqLduhuFwbVjpnvmb+A///7urA=
Date: Fri, 11 Oct 2013 14:54:13 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D2B155@ORSMSX106.amr.corp.intel.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <20131011080427.GC18719@pd.tnic>
In-Reply-To: <20131011080427.GC18719@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9BEsOQK030630

>> [56005.785981] {3}physical_address: 0x0000000851fe0000
>> [56005.786027] {3}DIMM location: Memriser1 CHANNEL A DIMM 0
>
> Very good guys, I've been waiting for years for this to be possible,
> good job! :-)

It's such a simple goal - I can't believe it took this long to get here :-)

> Btw, what's "Memriser1"?

Each memory controller on this machine routes to a plug-in card that has
a bunch of DIMMs on it.  The silkscreen labels on the motherboard for these
cards read "Memriser1" "Memriser2" etc.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
