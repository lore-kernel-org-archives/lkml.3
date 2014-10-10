Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaJJOLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:11:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:63172 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbaJJOKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:10:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,692,1406617200"; 
   d="scan'208";a="603383854"
Message-ID: <1412950247.7701.15.camel@linux.intel.com>
Subject: Re: [PATCH 2/2 v3] SPI: spi-pxa2xx: SPI support for Intel Quark
 X1000
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Chen, Alvin" <alvin.chen@intel.com>
Cc: "pure.logic@nexus-software.ie" <pure.logic@nexus-software.ie>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>
Date: Fri, 10 Oct 2014 17:10:47 +0300
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E998BCE@SHSMSX101.ccr.corp.intel.com>
References: <1412783423-9408-1-git-send-email-alvin.chen@intel.com>
	 <1412783423-9408-3-git-send-email-alvin.chen@intel.com>
	 <5436ECC6.9080704@nexus-software.ie>
	 <4656BEB6164FC34F8171C6538F1A595B2E998BCE@SHSMSX101.ccr.corp.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 00:46 +0000, Chen, Alvin wrote:
> > Doesn't apply.
> > 
> > Applying: SPI: spi-pxa2xx: SPI support for Intel Quark X1000
> > error: patch failed: drivers/spi/spi-pxa2xx-pci.c:19
> > error: drivers/spi/spi-pxa2xx-pci.c: patch does not apply Patch failed at 0002 SPI:
> > spi-pxa2xx: SPI support for Intel Quark X1000
> > 
> It is based on the slave-dma tree (git.infraded.org) for-linus branch, which will be reapplied on top of v3.19-rc1.
> More information can be got from Andy.

Actually if I understand correctly your series requires only one patch
to be applied from topic/spi-pxa2xx branch by Chiau Ee, though you have
to rearrange the code in the spi-pxa2xx-pci.c to not be closer to
Braswell stuff.

But again, it's only my guessing, you may try to rebase it on top of
topic branch mentioned above.


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

