Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaBSJ6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:58:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:16052 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbaBSJ6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:58:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,504,1389772800"; 
   d="scan'208";a="477568653"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 01/11 RESEND] mei: add mei_hbuf_acquire wrapper
Thread-Topic: [char-misc-next 01/11 RESEND] mei: add mei_hbuf_acquire wrapper
Thread-Index: AQHPK+JGKFcfb1suAUCtzk/7SkOr85q7LkqAgAEoLbA=
Date: Wed, 19 Feb 2014 09:58:08 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF74203@HASMSX106.ger.corp.intel.com>
References: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
 <1392642807-8878-2-git-send-email-tomas.winkler@intel.com>
 <20140218180357.GA15274@kroah.com>
In-Reply-To: <20140218180357.GA15274@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> This patch fails to apply to my char-misc-next branch (I've pulled in
> 3.14-rc3 into this branch now):
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
> 
> Care to fix this up and resend this series?


The patch 'mei: set client's read_cb to NULL when flow control fails' (accb884b32e82f943340688c9cd30290531e73e0)
Which is in char-misc-linus, still haven't make it to the  upstream...I thought it would be in rc3 already.

I can either fix the current series and then you will need to resolve quite simple conflict in merge (it's just a two line patch) or we wait for another cycle. 
I would prefer the first option as I have few more patches in the queue I won't to send for review but it's up to you.

Thanks
Tomas
