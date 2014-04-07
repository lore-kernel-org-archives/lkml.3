Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbaDGJBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 05:01:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:33439 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826AbaDGJBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 05:01:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,808,1389772800"; 
   d="scan'208";a="488498314"
Date: Mon, 7 Apr 2014 12:09:00 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Benson Leung <bleung@chromium.org>, khali@linux-fr.org,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        dlaurie@chromium.org
Subject: Re: [PATCH v2 0/2] i2c-designware-pci: Add Haswell ULT device support
Message-ID: <20140407090859.GH19349@intel.com>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
 <1382367944-3005-1-git-send-email-bleung@chromium.org>
 <20131021161428.GI3521@intel.com>
 <20140406135424.GA1840@node.dhcp.inet.fi>
 <20140406153104.GA2609@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140406153104.GA2609@katana>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 05:31:04PM +0200, Wolfram Sang wrote:
> On Sun, Apr 06, 2014 at 04:54:24PM +0300, Kirill A. Shutemov wrote:
> > On Mon, Oct 21, 2013 at 07:14:28PM +0300, Mika Westerberg wrote:
> > > On Mon, Oct 21, 2013 at 08:05:42AM -0700, Benson Leung wrote:
> > > > Fixed 25Mhz clock instead of 100Mhz clock in 1/2 and a warning in 2/2.
> > > > 
> > > > [PATCH v2 1/2] i2c-designware-pci: Add Haswell ULT device IDs
> > > > [PATCH v2 2/2] i2c-designware-pci: Index Haswell ULT bus names from 0
> > > 
> > > Both patches,
> > > 
> > > Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > 
> > Guys, any idea why these patches have not upstreamed yet?
> 
> Yes, read the discussion of V1 of these patches. AFAIU the patches are
> obsolete.

Well, we still don't have HSW PCI Ids in the driver.

Benson, are you still planning to send a patch to add those? I can add them
as well, if you are fine with that.
