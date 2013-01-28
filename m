Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab3A1MfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:35:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:64370 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab3A1MfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:35:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,551,1355126400"; 
   d="scan'208";a="195822983"
Date: Mon, 28 Jan 2013 04:10:01 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] dw_dmac: move soft LLP code from tasklet to
 dwc_scan_descriptors
Message-ID: <20130128120955.GR26562@intel.com>
References: <1358511255-6324-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAOh2x=n5_Z1oCXJH=CB7a-0b=9=ZZgqpxaMkyHsfg9LZdnpu+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x=n5_Z1oCXJH=CB7a-0b=9=ZZgqpxaMkyHsfg9LZdnpu+w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jan 18, 2013 at 5:44 PM, Andy Shevchenko
> > The proper place for the main logic of the soft LLP mode is
> > dwc_scan_descriptors. It prevents to get the transfer unexpectedly aborted in
> > case the user calls dwc_tx_status.
Can you rebase this, it failed to apply for me

--
~Vinod
