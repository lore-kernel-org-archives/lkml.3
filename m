Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbbACSxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 13:53:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49210 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbACSxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 13:53:41 -0500
Date: Sat, 3 Jan 2015 19:53:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nishanth Menon <nm@ti.com>
Cc: edubezval@gmail.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] cleanup ti-soc-thermal
Message-ID: <20150103185339.GB5950@amd>
References: <20150103111904.GA11545@amd>
 <20150103174804.GA20341@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150103174804.GA20341@kahuna>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2015-01-03 11:48:04, Nishanth Menon wrote:
> On 12:19-20150103, Pavel Machek wrote:
> > Simplify code by removing goto's where they point to simple return.
> > 
> > Avoid confusing |= on error values.
> 
> Please split these up into chunks of related changes. there is white
> space and quiet a few other changes all mixed in.
> 
> Also please cc linux-omap mailing list as well to get adequate
> audience.

Actually, if you want linux-omap list to be consistently cc-ed, you
may want to update MAINTAINERS entry.

Right now it says:

TI BANDGAP AND THERMAL DRIVER
M:      Eduardo Valentin <edubezval@gmail.com>
L:      linux-pm@vger.kernel.org
S:      Supported
F:      drivers/thermal/ti-soc-thermal/

									Pavel
									
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
