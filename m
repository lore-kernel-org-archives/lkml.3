Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161545AbaJaBEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:04:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:42581 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161426AbaJaBEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:04:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,290,1413270000"; 
   d="scan'208";a="599440768"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Haojian Zhuang" <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>
Subject: RE: [PATCH 1/2 v3] SPI: spi-pxa2xx: Add helpers for regiseters'
 accessing
Thread-Topic: [PATCH 1/2 v3] SPI: spi-pxa2xx: Add helpers for regiseters'
 accessing
Thread-Index: AQHP4s22TpHaDKncQEG+hgnoBCOPqpxGWjFggAAw1QCAAWjMwP//4h8AgAGwnUA=
Date: Fri, 31 Oct 2014 01:03:38 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E9A9417@SHSMSX101.ccr.corp.intel.com>
References: <1412783423-9408-1-git-send-email-alvin.chen@intel.com>
	 <1412783423-9408-2-git-send-email-alvin.chen@intel.com>
	 <4656BEB6164FC34F8171C6538F1A595B2E9A90E6@SHSMSX101.ccr.corp.intel.com>
	 <5450CF36.7060105@nexus-software.ie>
	 <4656BEB6164FC34F8171C6538F1A595B2E9A92B3@SHSMSX101.ccr.corp.intel.com>
 <1414653134.2396.67.camel@linux.intel.com>
In-Reply-To: <1414653134.2396.67.camel@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9V14RuA017320


> 
> On Thu, 2014-10-30 at 01:02 +0000, Chen, Alvin wrote:
> > > >
> > >
> > > Hi Alvin, Weike.
> > >
> > > I'm not clear if these patches apply to the current tip-of-tree.
> > >
> > > I thought the action required here, was for a resend of patches to
> > > ensure they applied to tip-of-tree ?
> > >
> > As I said before, it is based on the slave-dma tree (git.infraded.org) for-linus
> branch, which will be reapplied on top of v3.19-rc1.
> >
> > That is to say these patches will be applied to slave-dma tree for-linus branch,
> and then the slave-dma tree for-linus branch will be applied to v3.19.
> > Andy, am I right?
> 
> All of those patches are in v3.18-rc1, so you may rebase on top of 3.18-rcX
> safely I guess.
> 
Andy, I remember you ask me to rebase on the slave-dma tree (git.infraded.org) for-linus branch, and the slave-dma for-linus branch will be reapplied on top of v3.19-rc1.

So now I need rebase on top of 3.18-rcX, isn't it? Just to confirm.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
