Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaCaJr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 05:47:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:59061 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbaCaJrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 05:47:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,764,1389772800"; 
   d="scan'208";a="483873532"
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
To: Josh Triplett <josh@joshtriplett.org>
CC: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        intel-linux-scu <intel-linux-scu@intel.com>,
        "Patelczyk, Maciej" <maciej.patelczyk@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
Subject: RE: [PATCH 19/55] scsi: Mark function as static in isci/phy.c
Thread-Topic: [PATCH 19/55] scsi: Mark function as static in isci/phy.c
Thread-Index: AQHPS3lALYZ3HJR2Yk+SznwxKlEN6Jr65lUw///7VgCAABL7QA==
Date: Mon, 31 Mar 2014 09:47:18 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB208427B7@IRSMSX105.ger.corp.intel.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
 <aeac50e3686d8daafd573ebd08805b8a97d85ebd.1396114898.git.rashika.kheria@gmail.com>
 <D9FFE20C522965449E182ACE73889AEB20842693@IRSMSX105.ger.corp.intel.com>
 <af1d52ad252849d6a8c5d5b09fa93d17@fmsmsx103.amr.corp.intel.com>
In-Reply-To: <af1d52ad252849d6a8c5d5b09fa93d17@fmsmsx103.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2V9lYAQ025345

On Monday, March 31, 2014 11:36 AM Josh Triplett <josh@joshtriplett.org> wrote:
> On Mon, Mar 31, 2014 at 08:54:49AM +0000, Dorau, Lukasz wrote:
> > On Saturday, March 29, 2014 7:04 PM Rashika Kheria
> <rashika.kheria@gmail.com> wrote:
> > >
> > > Mark function as static in isci/phy.c because it is not used outside
> > > this file.
> > >
> > > This eliminates the following warning in isci/phy.c:
> > > drivers/scsi/isci/phy.c:672:6: warning: no previous prototype for
> > > â€˜scu_link_layer_set_txcomsas_timeoutâ€™ [-Wmissing-prototypes]
> > >
> > > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> >
> > Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>
> 
> Since you're a maintainer of the driver in question, can you accept the
> three patches you acked, or would you suggest that they go through
> another tree?
> 
> - Josh Triplett

Hi Josh,

The isci patches should be accepted by James Bottomley.

Lukasz

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
