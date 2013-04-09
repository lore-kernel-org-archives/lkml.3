Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936876Ab3DIJ33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:29:29 -0400
Received: from sauhun.de ([89.238.76.85]:48512 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936414Ab3DIJ30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:29:26 -0400
Date: Tue, 9 Apr 2013 11:29:24 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: Re: [4/7] i2c-designware: use dynamic adapter numbering on Lynxpoint
Message-ID: <20130409092923.GF3624@the-dreams.de>
References: <1363867800-23861-4-git-send-email-mika.westerberg@linux.intel.com>
 <20130409090605.GC28509@the-dreams.de>
 <20130409092319.GF21818@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409092319.GF21818@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 12:23:19PM +0300, Mika Westerberg wrote:
> On Tue, Apr 09, 2013 at 11:06:05AM +0200, Wolfram Sang wrote:
> > On Thu, Mar 21, 2013 at 02:09:57AM -0000, Mika Westerberg wrote:
> > > It is not good idea to mix static and dynamic I2C adapter numbering. In
> > > this particular case on Lynxpoint we had graphics I2C adapter which took
> > > the first numbers preventing the designware I2C driver from using the
> > > adapter numbers it preferred.
> > > 
> > > Fix this by switching to use dynamic adapter numbering on Intel Lynxpoint.
> > > 
> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > 
> > I am fearing regressions here if the bus numbering changes.
> 
> There are no users for this dynamic numbering yet since it was introduced
> with the Lynxpoint support.

Please add this to the commit msg.
