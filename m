Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbbAJWBJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:01:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:37081 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbbAJWBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:01:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,737,1413270000"; 
   d="scan'208";a="635473250"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 3/3 V2] mei: add reference counting for me
 clients
Thread-Topic: [char-misc-next 3/3 V2] mei: add reference counting for me
 clients
Thread-Index: AQHQCjrvq94s7xvI806gvBW27XCl4py4h7uAgAGMZVA=
Date: Sat, 10 Jan 2015 22:01:01 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B34B7D27C@HASMSX106.ger.corp.intel.com>
References: <1417090049-23219-1-git-send-email-tomas.winkler@intel.com>
 <1417090049-23219-3-git-send-email-tomas.winkler@intel.com>
 <20150109225153.GA20890@kroah.com>
In-Reply-To: <20150109225153.GA20890@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0AM1Laf011893

> >
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> 
> This patch adds build warnings, I can't take it:
> 
> drivers/misc/mei/bus.c: In function â€˜___mei_cl_sendâ€™:
> drivers/misc/mei/bus.c:276:3: warning: â€˜cbâ€™ may be used uninitialized in this
> function [-Wmaybe-uninitialized]
>    mei_io_cb_free(cb);
>    ^
> drivers/misc/mei/bus.c:273:2: warning: â€˜me_clâ€™ may be used uninitialized in this
> function [-Wmaybe-uninitialized]
>   mei_me_cl_put(me_cl);
>   ^

CONFIG_CC_OPTIMIZE_FOR_SIZE  is pushing -Wno-maybe-uninitialized so this didn't pop up. 
Resending 

Thanks
Tomas

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
