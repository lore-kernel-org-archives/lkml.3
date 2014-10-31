Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbaJaFpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 01:45:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:32697 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbaJaFpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 01:45:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,292,1413270000"; 
   d="scan'208";a="614551385"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        Eric Miao <eric.y.miao@gmail.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
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
Thread-Index: AQHP4s22TpHaDKncQEG+hgnoBCOPqpxGWjFggAAw1QCAAWjMwP//4h8AgAGwnUCAAE6T0A==
Date: Fri, 31 Oct 2014 05:43:08 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E9A9CB6@SHSMSX101.ccr.corp.intel.com>
References: <1412783423-9408-1-git-send-email-alvin.chen@intel.com>
	 <1412783423-9408-2-git-send-email-alvin.chen@intel.com>
	 <4656BEB6164FC34F8171C6538F1A595B2E9A90E6@SHSMSX101.ccr.corp.intel.com>
	 <5450CF36.7060105@nexus-software.ie>
	 <4656BEB6164FC34F8171C6538F1A595B2E9A92B3@SHSMSX101.ccr.corp.intel.com>
 <1414653134.2396.67.camel@linux.intel.com> 
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9V5jof7018634

> >
> > All of those patches are in v3.18-rc1, so you may rebase on top of
> > 3.18-rcX safely I guess.
> >
> Andy, I remember you ask me to rebase on the slave-dma tree (git.infraded.org)
> for-linus branch, and the slave-dma for-linus branch will be reapplied on top of
> v3.19-rc1.
> 
Just to confirm, these patches can be applied well on top of 3.18-rc2.

> So now I need rebase on top of 3.18-rcX, isn't it? Just to confirm.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
