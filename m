Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab3BSJD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:03:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:48956 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab3BSJDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:03:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,693,1355126400"; 
   d="scan'208";a="292954006"
Message-ID: <1361264544.28241.52.camel@smile>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line
 base
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>
Date: Tue, 19 Feb 2013 11:02:24 +0200
In-Reply-To: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 13:04 +0200, Andy Shevchenko wrote: 
> On some hardware configurations we have got the request line with the offset.
> The patch introduces convert_slave_id() helper for that cases. The request line
> base is got from the platform device resources provided by the IORESOURCE_DMA
> type.

Hi, Vinod.

v3.8 is just out, and we have not got any proposal from anyone how to
make our approach better. So, I'm just wondering about current state.

Rafael, could you share your opinion about our case with CSRT and
request line base (perhaps you need to go through the entire thread)?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
