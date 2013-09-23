Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3IWLAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 07:00:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:33274 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab3IWLAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:00:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,961,1371106800"; 
   d="scan'208";a="405771795"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Anton Vorontsov <anton@enomsg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] power_supply: Add power_supply notifier
Thread-Topic: [PATCH] power_supply: Add power_supply notifier
Thread-Index: AQHOiSneoS37shnxEkGTrfDlIWB+VpmM9daAgEaJuKA=
Date: Mon, 23 Sep 2013 11:00:45 +0000
Message-ID: <20ADAB092842284E95860F279283C5640AA1058F@BGSMSX104.gar.corp.intel.com>
References: <1374780069-23670-1-git-send-email-jenny.tc@intel.com>
 <20130809185640.GC979@lizard.mcd26095.sjc.wayport.net>
In-Reply-To: <20130809185640.GC979@lizard.mcd26095.sjc.wayport.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8NB1EPN016046

Anton,

I submitted 7 patches together which includes this patch also. Hope this would give more insight to the features.

-Jenny

> -----Original Message-----
> From: Anton Vorontsov [mailto:anton@scarybugs.org] On Behalf Of Anton Vorontsov
> Sent: Saturday, August 10, 2013 12:27 AM
> To: Tc, Jenny
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] power_supply: Add power_supply notifier
> 
> On Fri, Jul 26, 2013 at 12:51:09AM +0530, Jenny TC wrote:
> > This patch adds a notifier chain to the power_supply.
> > This notifier helps drivers in other subsystem to listen to changes in
> > power supply subsystem. This would help to take some actions in those
> > drivers on changing the power supply properties.
> > One such scenario is to increase/decrease system performance based on
> > the battery capacity/voltage. Another scenario is to adjust the h/w
> > peak current detection voltage/current thresholds based on battery
> > voltage/capacity. The notifier helps drivers to listen to changes in
> > power_suppy susbystem without polling the power_supply properties
> >
> > Signed-off-by: Jenny TC <jenny.tc@intel.com>
> > ---
> 
> Hi Jenny,
> 
> Can you please submit users of this new API as well, so that we could see the whole
> picture?
> 
> Thanks,
> 
> Anton
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
