Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3KFUDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:03:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:21794 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab3KFUDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:03:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,647,1378882800"; 
   d="scan'208";a="423351875"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
CC: "Usyskin, Alexander" <alexander.usyskin@intel.com>,
        Nicol? Costanza <abitrules@yahoo.it>,
        Alex Burmashev <alex.burmashev@rosalab.ru>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: mei: cancel stall timers in mei_reset
Thread-Topic: mei: cancel stall timers in mei_reset
Thread-Index: AQHO1v25eHT6rrwZAkeTBc+srO32QJoTJVWQgAH12wCAARFxgIAAHv+AgAAeFACAACHsAIABJEKAgAD0PAA=
Date: Wed, 6 Nov 2013 20:03:34 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF0656E@HASMSX106.ger.corp.intel.com>
References: <1361817048.3583.1383580128332.JavaMail.root@collab.rosalab.ru>
 <5278A741.6040206@rosalab.ru>
 <C980C034A53E0646B96866D6CE3D187A3330D460@HASMSX106.ger.corp.intel.com>
 <5278DA7C.6010708@rosalab.ru>
 <5B8DA87D05A7694D9FA63FD143655C1B1AF03AB6@HASMSX106.ger.corp.intel.com>
 <5279EC1B.1040709@rosalab.ru>
In-Reply-To: <5279EC1B.1040709@rosalab.ru>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA6K3jrC027368



> -----Original Message-----
> From: Eugene Shatokhin [mailto:eugene.shatokhin@rosalab.ru]
> Sent: Wednesday, November 06, 2013 09:14
> To: Winkler, Tomas
> Cc: Usyskin, Alexander; NicolÃ² Costanza; Alex Burmashev; LKML
> Subject: Re: mei: cancel stall timers in mei_reset
> 
> Hi,
> 
>  > Please try to comment out schedule_delayed_work(&dev->timer_work,
> HZ); in pci-me.c
> 
> You mean this call in mei_me_pci_resume() rather than in .probe, I
> suppose? There are two such calls in pci-me.c.
>

You can safely comment out all of the timer_work.
 
Thanks
Tomas
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
