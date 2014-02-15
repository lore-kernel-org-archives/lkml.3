Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaBOHqy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 02:46:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:20097 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaBOHqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 02:46:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,849,1384329600"; 
   d="scan'208";a="455958761"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 3/4] mei: add mei_hbuf_acquire wrapper
Thread-Topic: [char-misc-next 3/4] mei: add mei_hbuf_acquire wrapper
Thread-Index: AQHPKbi4DPm9h1yYRkGxy6wpWqtSk5q17lPg
Date: Sat, 15 Feb 2014 07:46:49 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF721AA@HASMSX106.ger.corp.intel.com>
References: <1392234114-4926-1-git-send-email-tomas.winkler@intel.com>
 <1392234114-4926-4-git-send-email-tomas.winkler@intel.com>
 <20140214191338.GA423@kroah.com>
In-Reply-To: <20140214191338.GA423@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This patch fails to apply:
> 	checking file drivers/misc/mei/amthif.c
> 	checking file drivers/misc/mei/client.c
> 	Hunk #4 FAILED at 681.
> 	Hunk #5 succeeded at 815 (offset -2 lines).
> 	Hunk #6 succeeded at 848 (offset -2 lines).
> 	1 out of 6 hunks FAILED
> 	checking file drivers/misc/mei/hw-me.c
> 	checking file drivers/misc/mei/hw-txe.c
> 	checking file drivers/misc/mei/interrupt.c
> 	checking file drivers/misc/mei/mei_dev.h
> 	checking file drivers/misc/mei/wd.c

Did I missed something in the process? 
This patch series has dependency on path that was destined for stable https://lkml.org/lkml/2014/2/12/389
 as stated in 0/4 http://www.spinics.net/lists/kernel/msg1686728.html
Quoting:
"In order to avoid conflicts please apply after
mei: set client's read_cb to NULL when flow control fails
https://lkml.org/lkml/2014/2/12/389"


Thanks
Tomas

