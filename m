Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaKCSvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:51:20 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:36334 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaKCSvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:51:19 -0500
Date: Mon, 3 Nov 2014 10:51:08 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Felipe Balbi <balbi@ti.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, nsekhar@ti.com,
        grant.likely@linaro.org, George Cherian <george.cherian@ti.com>
Subject: Re: [PATCH 1/4] extcon: gpio: Convert the driver to use gpio desc
 API's
Message-ID: <20141103185101.GC10558@roeck-us.net>
References: <1415032350-8459-1-git-send-email-balbi@ti.com>
 <1415032350-8459-2-git-send-email-balbi@ti.com>
 <20141103180150.GA10164@roeck-us.net>
 <20141103180602.GU27425@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103180602.GU27425@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.5457CEA6.0340,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 14
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 12:06:02PM -0600, Felipe Balbi wrote:
> On Mon, Nov 03, 2014 at 10:01:50AM -0800, Guenter Roeck wrote:
> > On Mon, Nov 03, 2014 at 10:32:27AM -0600, Felipe Balbi wrote:
> > > From: George Cherian <george.cherian@ti.com>
> > > 
> > > Convert the driver to use gpiod_* API's.
> > > 
> > > Reviewed-by: Roger Quadros <rogerq@ti.com>
> > > Signed-off-by: George Cherian <george.cherian@ti.com>
> > > Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > ---
> > 
> > I think it might be useful and appropriate to explain that and why
> > you remove support for active-low pins, instead of hiding it in a
> > seemingly unrelated patch.
> 
> removed ? why removed ? gpio descs handle that for you, read the source
> code.
> 
Well, it for sure looks like it. Care to explain that in the patch,
as well as how the platform data flag is used ?

Thanks,
Guenter
