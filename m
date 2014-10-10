Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbaJJAqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 20:46:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:30844 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaJJAqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 20:46:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="397925610"
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
Subject: RE: [PATCH 2/2 v3] SPI: spi-pxa2xx: SPI support for Intel Quark
 X1000
Thread-Topic: [PATCH 2/2 v3] SPI: spi-pxa2xx: SPI support for Intel Quark
 X1000
Thread-Index: AQHP5ABhBYMv9BXqw0GBn2WRmFy7CJwofThw
Date: Fri, 10 Oct 2014 00:46:18 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E998BCE@SHSMSX101.ccr.corp.intel.com>
References: <1412783423-9408-1-git-send-email-alvin.chen@intel.com>
 <1412783423-9408-3-git-send-email-alvin.chen@intel.com>
 <5436ECC6.9080704@nexus-software.ie>
In-Reply-To: <5436ECC6.9080704@nexus-software.ie>
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

> Hi Alvin,
> 
> Doesn't apply.
> 
> Applying: SPI: spi-pxa2xx: SPI support for Intel Quark X1000
> error: patch failed: drivers/spi/spi-pxa2xx-pci.c:19
> error: drivers/spi/spi-pxa2xx-pci.c: patch does not apply Patch failed at 0002 SPI:
> spi-pxa2xx: SPI support for Intel Quark X1000
> 
It is based on the slave-dma tree (git.infraded.org) for-linus branch, which will be reapplied on top of v3.19-rc1.
More information can be got from Andy.


> --
> Bryan
