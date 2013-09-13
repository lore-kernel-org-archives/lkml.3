Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3IMJMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 05:12:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:43022 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab3IMJMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:12:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,897,1371106800"; 
   d="scan'208";a="377626404"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mei: me: downgrade "suspend" message to debug level
Thread-Topic: [PATCH] mei: me: downgrade "suspend" message to debug level
Thread-Index: AQHOr+zMZDFpNkqohU+J51+VgPGZDJnCSycAgAEXrMA=
Date: Fri, 13 Sep 2013 09:12:44 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AEC3CE1@HASMSX106.ger.corp.intel.com>
References: <1379013442.11313.5.camel@x220.thuisdomein>
 <1379014276.11313.9.camel@x220.thuisdomein>
In-Reply-To: <1379014276.11313.9.camel@x220.thuisdomein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8D9DKvS019188


> >
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > Lightly tested (on top of v3.10.10, actually). Should apply cleanly to
> > v3.11 or current master.
> >
> > Perhaps a better fix is to remove this message entirely.
> 
> Rechecking my logs I noticed a "stop" error on module unload. That
> message could be downgraded to debug level too. But it could also be
> removed. If Tomas could say what is preferable I'll send a second
> version of this trivial patch.

I prefer to have it on debug level. 
Thanks
Tomas
 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
