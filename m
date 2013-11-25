Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab3KYLld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:41:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:35313 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3KYLlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:41:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,767,1378882800"; 
   d="scan'208";a="439249640"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Masanari Iida <standby24x7@gmail.com>,
        "trivial@kernel.org" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] [trivial] mei: Fix typo in mei drivers
Thread-Topic: [PATCH 3/3] [trivial] mei: Fix typo in mei drivers
Thread-Index: AQHO6ZN636mzF6MUPEu4Yr6ZKAkn4Jo10ohg
Date: Mon, 25 Nov 2013 11:40:18 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF1C7E6@HASMSX106.ger.corp.intel.com>
References: <1385220974-3469-1-git-send-email-standby24x7@gmail.com>
 <1385220974-3469-3-git-send-email-standby24x7@gmail.com>
 <5292CC5E.3000405@infradead.org>
In-Reply-To: <5292CC5E.3000405@infradead.org>
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
> >  drivers/misc/mei/amthif.c  |  4 ++--
> >  drivers/misc/mei/debugfs.c |  2 +-
> >  drivers/misc/mei/hbm.c     | 12 ++++++------
> >  drivers/misc/mei/mei_dev.h |  2 +-
> >  4 files changed, 10 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
> > index e3870f2..10b172a 100644
> > --- a/drivers/misc/mei/debugfs.c
> > +++ b/drivers/misc/mei/debugfs.c
> > @@ -43,7 +43,7 @@ static ssize_t mei_dbgfs_read_meclients(struct file *fp, char
> __user *ubuf,
> >
> >  	mutex_lock(&dev->device_lock);
> >
> > -	/*  if the driver is not enabled the list won't b consitent */
> > +	/*  if the driver is not enabled the list won't b consistent */
> 
> 	                                                be


Actually, this I already  have fixed in my queue. 
Will post shortly 

Thanks
Tomas
