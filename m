Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab3JUQJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 12:09:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:3341 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab3JUQJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 12:09:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,539,1378882800"; 
   d="scan'208";a="420244881"
Date: Mon, 21 Oct 2013 19:14:28 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Benson Leung <bleung@chromium.org>
Cc: wsa@the-dreams.de, khali@linux-fr.org, andriy.shevchenko@linux.intel.com,
        jacmet@sunsite.dk, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, dlaurie@chromium.org
Subject: Re: [PATCH v2 0/2] i2c-designware-pci: Add Haswell ULT device support
Message-ID: <20131021161428.GI3521@intel.com>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
 <1382367944-3005-1-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382367944-3005-1-git-send-email-bleung@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 08:05:42AM -0700, Benson Leung wrote:
> Fixed 25Mhz clock instead of 100Mhz clock in 1/2 and a warning in 2/2.
> 
> [PATCH v2 1/2] i2c-designware-pci: Add Haswell ULT device IDs
> [PATCH v2 2/2] i2c-designware-pci: Index Haswell ULT bus names from 0

Both patches,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks.
