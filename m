Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaKFSwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:52:10 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:44938 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaKFSwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:52:04 -0500
Date: Thu, 6 Nov 2014 10:51:58 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v5 36/48] arm64: psci: Register with kernel power-off
 handler
Message-ID: <20141106185158.GC31712@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
 <1415292213-28652-37-git-send-email-linux@roeck-us.net>
 <20141106172222.GA15384@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106172222.GA15384@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.545BC354.019D,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 16
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

On Thu, Nov 06, 2014 at 05:22:23PM +0000, Mark Rutland wrote:
> On Thu, Nov 06, 2014 at 04:43:20PM +0000, Guenter Roeck wrote:
> > Register with kernel power-off handler instead of setting pm_power_off
> > directly.
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> 
> I just fetched your current poweroff-handler branch and gave it a spin
> on Juno. It looks like this hasn't broken since the last time I tried
> it. :)
> 
> Tested-by: Mark Rutland <mark.rutland@arm.com>
> 
Thanks a lot!

Guenter
