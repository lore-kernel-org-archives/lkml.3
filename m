Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbaJ3HMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 03:12:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:60996 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758122AbaJ3HMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 03:12:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,284,1413270000"; 
   d="scan'208";a="623291564"
Message-ID: <1414653134.2396.67.camel@linux.intel.com>
Subject: Re: [PATCH 1/2 v3] SPI: spi-pxa2xx: Add helpers for regiseters'
 accessing
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Chen, Alvin" <alvin.chen@intel.com>
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
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
Date: Thu, 30 Oct 2014 09:12:14 +0200
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E9A92B3@SHSMSX101.ccr.corp.intel.com>
References: <1412783423-9408-1-git-send-email-alvin.chen@intel.com>
	 <1412783423-9408-2-git-send-email-alvin.chen@intel.com>
	 <4656BEB6164FC34F8171C6538F1A595B2E9A90E6@SHSMSX101.ccr.corp.intel.com>
	 <5450CF36.7060105@nexus-software.ie>
	 <4656BEB6164FC34F8171C6538F1A595B2E9A92B3@SHSMSX101.ccr.corp.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-30 at 01:02 +0000, Chen, Alvin wrote:
> > >
> > 
> > Hi Alvin, Weike.
> > 
> > I'm not clear if these patches apply to the current tip-of-tree.
> > 
> > I thought the action required here, was for a resend of patches to ensure they
> > applied to tip-of-tree ?
> > 
> As I said before, it is based on the slave-dma tree (git.infraded.org) for-linus branch, which will be reapplied on top of v3.19-rc1. 
> 
> That is to say these patches will be applied to slave-dma tree for-linus branch, and then the slave-dma tree for-linus branch will be applied to v3.19.
> Andy, am I right?

All of those patches are in v3.18-rc1, so you may rebase on top of
3.18-rcX safely I guess.


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

