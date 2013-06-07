Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3FGFVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:21:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:42180 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab3FGFVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:21:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,819,1363158000"; 
   d="scan'208";a="349513406"
Date: Fri, 7 Jun 2013 08:25:55 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Jean Delvare <khali@linux-fr.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: designware: make i2c xfers non-interruptible
Message-ID: <20130607052555.GC11878@intel.com>
References: <1370526216-10060-1-git-send-email-christian.ruppert@abilis.com>
 <1370526216-10060-2-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370526216-10060-2-git-send-email-christian.ruppert@abilis.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 03:43:36PM +0200, Christian Ruppert wrote:
> When the process at the source of an i2c transfer is killed in the
> middle of the transfer, the transfer is interrupted. Interrupted
> transfers might cause buggy slaves on the bus (or higher level drivers)
> to go haywire.
> This patch forces ongoing i2c transfers to finish properly, even if the
> initiating process is killed.

I already sent a similar patch ;-)

https://patchwork.kernel.org/patch/2601241/

However, it is not yet picked by Wolfram.
