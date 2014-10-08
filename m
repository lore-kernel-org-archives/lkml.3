Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaJHHsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:48:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:21630 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbaJHHsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:48:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,675,1406617200"; 
   d="scan'208";a="602163856"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: "pure.logic@nexus-software.ie" <pure.logic@nexus-software.ie>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Haojian Zhuang" <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: RE: [PATCH 2/2 v2] SPI: spi-pxa2xx: SPI support for Intel Quark
 X1000
Thread-Topic: [PATCH 2/2 v2] SPI: spi-pxa2xx: SPI support for Intel Quark
 X1000
Thread-Index: AQHP4pO2Z8Oqj7luBkykxkjhubrehJwl0k6w
Date: Wed, 8 Oct 2014 07:48:24 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E997E59@SHSMSX101.ccr.corp.intel.com>
References: <1412000548-9908-1-git-send-email-alvin.chen@intel.com>
 <1412000548-9908-3-git-send-email-alvin.chen@intel.com>
 <54348D56.20708@nexus-software.ie>
In-Reply-To: <54348D56.20708@nexus-software.ie>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> On 29/09/14 15:22, Weike Chen wrote:
> > +		.num_chipselect = 4,
> 
> How is this right ?
> 
> There's only one physical chip-select line per SPI master...
> 
> It's a 1:1 mapping.
> 
Now, we have another board which can support 4 slave spi per master, but not only Galileo. Since that board is not public, after discussing with team, we decide to make the
upstream code to support '1'.

I will change it back to 
.num_chipselect = 1,


> Best,
> Bryan
