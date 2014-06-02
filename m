Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbaFBPP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:15:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:41410 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbaFBPPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:15:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,957,1392192000"; 
   d="scan'208";a="521497928"
User-Agent: Microsoft-MacOutlook/14.4.1.140326
Date: Mon, 02 Jun 2014 08:16:08 -0700
Subject: Re: [PATCH 2/2] clkdev: Export clk_register_clkdev
From: Darren Hart <dvhart@linux.intel.com>
To: Mark Brown <broonie@kernel.org>, Chew Chiau Ee <chiau.ee.chew@intel.com>
CC: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Message-ID: <CFB1E2EA.94DEE%dvhart@linux.intel.com>
Thread-Topic: [PATCH 2/2] clkdev: Export clk_register_clkdev
References: <1401738379-4107-1-git-send-email-chiau.ee.chew@intel.com>
 <1401738379-4107-3-git-send-email-chiau.ee.chew@intel.com>
 <20140602123522.GB31751@sirena.org.uk>
In-Reply-To: <20140602123522.GB31751@sirena.org.uk>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/14, 5:35, "Mark Brown" <broonie@kernel.org> wrote:

>On Tue, Jun 03, 2014 at 03:46:19AM +0800, Chew Chiau Ee wrote:
>> From: Darren Hart <dvhart@linux.intel.com>
>> 
>> Allow spi-pxa2xx-pci with common clock framework support to build as a
>> module by exporting clk_register_clkdev.
>
>This needs to be patch 1 in the series not patch 2 since the change to
>the driver to use the exported symbol depends on this rather than the
>other way around.
>

That was going to be my only comment as well. It's important to ensure
things build consistently through the git history. Git bisect is a key use
case here, breaking that makes for very cranky kernel engineers :-)
Dependencies first, new mechanisms second.

-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



