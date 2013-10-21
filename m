Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab3JUGwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 02:52:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:37312 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab3JUGwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 02:52:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="310431183"
Date: Mon, 21 Oct 2013 09:58:04 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Benson Leung <bleung@chromium.org>
Cc: wsa@the-dreams.de, khali@linux-fr.org, andriy.shevchenko@linux.intel.com,
        jacmet@sunsite.dk, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, dlaurie@chromium.org
Subject: Re: [PATCH 2/2] i2c-designware-pci: Index Haswell ULT bus names from
 0
Message-ID: <20131021065804.GX3521@intel.com>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
 <1382326010-4554-3-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382326010-4554-3-git-send-email-bleung@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 08:26:50PM -0700, Benson Leung wrote:
> Rather than having the bus names be "i2c-designware-pci--1" because
> we have set the .bus_num to -1 to force dynamic allocation, lets have
> the busses named "i2c-designware-pci-0" and "i2c-designware-pci-1"
> to correspond to the correct names of these busses.
> 
> The adapter number will still be dynamically assigned.

Is there any real value in having names like "i2c-designware-pci-0"
available? I would just drop the whole naming dance instead...
