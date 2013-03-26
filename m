Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab3CZWrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:47:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:57696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab3CZWrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:47:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,915,1355126400"; 
   d="scan'208";a="219199961"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 2/2] mei: drop RECOVERING_FROM_RESET device
 state
Thread-Topic: [char-misc-next 2/2] mei: drop RECOVERING_FROM_RESET device
 state
Thread-Index: AQHOKZZ3FWC0p/imNUis62STLDcs+pi4iYwg
Date: Tue, 26 Mar 2013 22:47:31 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01EF3427@HASMSX106.ger.corp.intel.com>
References: <1363513281-12606-1-git-send-email-tomas.winkler@intel.com>
 <1363513281-12606-2-git-send-email-tomas.winkler@intel.com>
 <20130325202146.GA14900@kroah.com>
In-Reply-To: <20130325202146.GA14900@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2QMlo2G007746

> 
> On Sun, Mar 17, 2013 at 11:41:21AM +0200, Tomas Winkler wrote:
> > ECOVERING_FROM_RESET device state is never set we can remove it
> 
> Really?  I now get the following build error with this patch applied:
> 
> drivers/misc/mei/pci-me.c: In function â€˜mei_pci_suspendâ€™:
> drivers/misc/mei/pci-me.c:323:24: error:
> â€˜MEI_DEV_RECOVERING_FROM_RESETâ€™ undeclared (first use in this
> function)
> drivers/misc/mei/pci-me.c:323:24: note: each undeclared identifier is
> reported only once for each function it appears in
> 
> Please be more careful.

This patch has to be applied above patch  https://lkml.org/lkml/2013/3/10/101 that is queued for 3.9. 
Somehow I've assumed it will go into 3.9-rc4.  
Anyhow we need to wait with this and everything else I have queued till it is merged back to char-misc-next.
Maybe you have some suggestions how to handle such conflicts in the future.

Thanks
Tomas
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
