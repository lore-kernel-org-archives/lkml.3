Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbbAMO3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:29:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:65235 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbbAMO3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:29:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="661130786"
Date: Tue, 13 Jan 2015 16:29:30 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Jisheng Zhang <jszhang@marvell.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] i2c: designware: use {readl|writel}_relaxed instead of
 readl/writel
Message-ID: <20150113142930.GT1386@lahna.fi.intel.com>
References: <1418279201-3886-1-git-send-email-jszhang@marvell.com>
 <20141219104315.0ccbba9c@xhacker>
 <20150113115205.GE7660@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113115205.GE7660@katana>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 12:52:05PM +0100, Wolfram Sang wrote:
> On Fri, Dec 19, 2014 at 10:43:15AM +0800, Jisheng Zhang wrote:
> > Dear all,
> > 
> > Is there any issue I need to resolve so that the patch can be merged?
> 
> Adding Mika to the loop. He uses the driver a lot (and knows other
> people who do)...

I don't see problems with this patch.

On x86 we have readl_relaxed() the same as readl() so this patch does
not change anything there.

Feel free to add,

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
