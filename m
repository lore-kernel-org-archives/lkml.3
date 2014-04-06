Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaDFNyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 09:54:43 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:37947 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbaDFNyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 09:54:40 -0400
Date: Sun, 6 Apr 2014 16:54:24 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Benson Leung <bleung@chromium.org>, wsa@the-dreams.de, khali@linux-fr.org,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        dlaurie@chromium.org
Subject: Re: [PATCH v2 0/2] i2c-designware-pci: Add Haswell ULT device support
Message-ID: <20140406135424.GA1840@node.dhcp.inet.fi>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
 <1382367944-3005-1-git-send-email-bleung@chromium.org>
 <20131021161428.GI3521@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131021161428.GI3521@intel.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 07:14:28PM +0300, Mika Westerberg wrote:
> On Mon, Oct 21, 2013 at 08:05:42AM -0700, Benson Leung wrote:
> > Fixed 25Mhz clock instead of 100Mhz clock in 1/2 and a warning in 2/2.
> > 
> > [PATCH v2 1/2] i2c-designware-pci: Add Haswell ULT device IDs
> > [PATCH v2 2/2] i2c-designware-pci: Index Haswell ULT bus names from 0
> 
> Both patches,
> 
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Guys, any idea why these patches have not upstreamed yet?

-- 
 Kirill A. Shutemov
