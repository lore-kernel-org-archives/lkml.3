Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaCKLDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:03:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:60540 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbaCKLDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:03:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,630,1389772800"; 
   d="scan'208";a="497602352"
Date: Tue, 11 Mar 2014 13:11:02 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Lim Lee Booi <lee.booi.lim@intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 RESEND] i2c: designware-pci: set ideal HCNT, LCNT and
 SDA hold time value
Message-ID: <20140311111102.GZ5018@intel.com>
References: <1394537625-27205-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394537625-27205-1-git-send-email-chiau.ee.chew@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 07:33:45PM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> On Intel BayTrail, there was case whereby the resulting fast mode
> bus speed becomes slower (~20% slower compared to expected speed)
> if using the HCNT/LCNT calculated in the core layer. Thus, this
> patch is added to allow pci glue layer to pass in optimal
> HCNT/LCNT/SDA hold time values to core layer since the core
> layer supports cofigurable HCNT/LCNT/SDA hold time values now.
> 
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
