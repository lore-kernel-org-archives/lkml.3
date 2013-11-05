Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab3KELt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:49:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:39449 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab3KELtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:49:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="403845105"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
CC: Nicol? Costanza <abitrules@yahoo.it>,
        Alex Burmashev <alex.burmashev@rosalab.ru>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: mei: cancel stall timers in mei_reset
Thread-Topic: mei: cancel stall timers in mei_reset
Thread-Index: AQHO1v25eHT6rrwZAkeTBc+srO32QJoTJVWQgAH12wCAARFxgIAAHv+AgAAeFACAACHsAA==
Date: Tue, 5 Nov 2013 11:49:50 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF03AB6@HASMSX106.ger.corp.intel.com>
References: <1361817048.3583.1383580128332.JavaMail.root@collab.rosalab.ru>
 <5278A741.6040206@rosalab.ru>
 <C980C034A53E0646B96866D6CE3D187A3330D460@HASMSX106.ger.corp.intel.com>
 <5278DA7C.6010708@rosalab.ru>
In-Reply-To: <5278DA7C.6010708@rosalab.ru>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA5Bo1cZ017114


> Hi,
> 
> On 11/05/2013 01:58 PM, Usyskin, Alexander wrote:
> > The problem that you found was fixed in patch here:
> https://lkml.org/lkml/2013/6/23/169
> > And this patch merged into 3.11 according to http://lxr.free-
> electrons.com/source/drivers/misc/mei/mei_dev.h?v=3.11
> > Can you re-check with latest 3.11 point release?
> 
> Thanks for the info!
> 
> Yes, I found this patch an hour ago as well as a similar one for hw_reset.
> 
> As we are currently more interested in kernel 3.10.x in ROSA (it is our
> main production kernel), I will apply these patches to it first and
> re-check.
>
This patches only catch the error, our goal is to discover why it is failing. 
Thanks
Tomas
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
