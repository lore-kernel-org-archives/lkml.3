Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3A1MqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:46:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:33842 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580Ab3A1MqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:46:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,551,1355126400"; 
   d="scan'208";a="277459755"
Message-ID: <1359377164.31148.0.camel@smile>
Subject: Re: [PATCH] dw_dmac: move soft LLP code from tasklet to
 dwc_scan_descriptors
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Date: Mon, 28 Jan 2013 14:46:04 +0200
In-Reply-To: <20130128120955.GR26562@intel.com>
References: <1358511255-6324-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=n5_Z1oCXJH=CB7a-0b=9=ZZgqpxaMkyHsfg9LZdnpu+w@mail.gmail.com>
	 <20130128120955.GR26562@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 04:10 -0800, Vinod Koul wrote: 
> > On Fri, Jan 18, 2013 at 5:44 PM, Andy Shevchenko
> > > The proper place for the main logic of the soft LLP mode is
> > > dwc_scan_descriptors. It prevents to get the transfer unexpectedly aborted in
> > > case the user calls dwc_tx_status.
> Can you rebase this, it failed to apply for me

It seems it's already applied.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
