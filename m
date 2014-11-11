Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaKKSiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:38:09 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:51470 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaKKSiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:38:07 -0500
Date: Tue, 11 Nov 2014 10:37:52 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Neelesh Gupta <neelegup@linux.vnet.ibm.com>, jdelvare@suse.de,
        benh@au1.ibm.com, linux-kernel@vger.kernel.org, michaele@au1.ibm.com,
        linuxppc-dev@lists.ozlabs.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2] hwmon: (ibmpowernv) Use platform 'id_table' to probe
 the device
Message-ID: <20141111183752.GA23539@roeck-us.net>
References: <20141105110848.6183.55611.stgit@localhost.localdomain>
 <20141105142149.GA23212@roeck-us.net>
 <1415574297.29291.3.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415574297.29291.3.camel@concordia>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5462578E.0197,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
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

On Mon, Nov 10, 2014 at 10:04:57AM +1100, Michael Ellerman wrote:
> On Wed, 2014-11-05 at 06:21 -0800, Guenter Roeck wrote:
> > On Wed, Nov 05, 2014 at 04:45:14PM +0530, Neelesh Gupta wrote:
> > > The current driver probe() function assumes the sensor device to be
> > > alwary present and gets executed every time if the driver is loaded,
> > > but the appropriate hardware could not be present.
> > > 
> > > So, move the platform device creation as part of platform init code
> > > and use the 'id_table' to check if the device present or not.
> > > 
> > > Signed-off-by: Neelesh Gupta <neelegup@linux.vnet.ibm.com>
> > 
> > Looks good. We'll need an ack from one of the powerpc maintainers to proceed.
> 
> Looks OK to me.
> 
> Acked-by: Michael Ellerman <mpe@ellerman.id.au>
> 
Applied to -next.

Thanks,
Guenter
