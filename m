Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaKCShD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:37:03 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:34339 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaKCShA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:37:00 -0500
Date: Mon, 3 Nov 2014 10:36:53 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Felipe Balbi <balbi@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 09/47] mfd: palmas: Register with kernel power-off
 handler
Message-ID: <20141103183653.GA10558@roeck-us.net>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-10-git-send-email-linux@roeck-us.net>
 <20141103175645.GT12011@x1>
 <20141103175954.GT27425@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103175954.GT27425@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.5457CB4C.0019,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
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

On Mon, Nov 03, 2014 at 11:59:54AM -0600, Felipe Balbi wrote:
> On Mon, Nov 03, 2014 at 05:56:45PM +0000, Lee Jones wrote:
> > On Mon, 27 Oct 2014, Guenter Roeck wrote:
> > 
> > > Register with kernel power-off handler instead of setting pm_power_off
> > > directly. Register with low priority to reflect that the original code
> > > only sets pm_power_off if it was not already set.
> > > 
> > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > Cc: Lee Jones <lee.jones@linaro.org>
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > ---
> > > v3:
> > > - Replace poweroff in all newly introduced variables and in text
> > >   with power_off or power-off as appropriate
> > > - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> > > v2:
> > > - Use define to specify poweroff handler priority
> > > - Use devm_register_power_off_handler
> > > - Use dev_warn instead of dev_err
> > > 
> > >  drivers/mfd/palmas.c       | 31 +++++++++++++++++--------------
> > >  include/linux/mfd/palmas.h |  3 +++
> > >  2 files changed, 20 insertions(+), 14 deletions(-)
> > 
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> missed lakml and linux-omap.
> 
Felipe,

unfortunately, get_maintainer.pl doesn't give a hint that this and the
other affected patches should be sent to linux-omap. How am I supposed
to know ?

Note that linux-kernel@vger.kernel.org was copied on the entire series,
if that is what you mean with lakml. linux-pm@vger.kernel.org was also
copied on all patches. Additional mailing lists were only copied for
affected architectures to avoid for the patches to be tagged as spam.

If there is a list named lakml, I must have missed it, and I seem to be
unable to find a reference to it. If that is the case, my apologies,
and please provide a link to it.

Thanks,
Guenter
