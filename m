Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaJGQbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:31:43 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:49868 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaJGQbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:31:41 -0400
Date: Tue, 7 Oct 2014 09:31:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, adi-buildroot-devel@lists.sourceforge.net,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-am33-list@redhat.com,
        linux-cris-kernel@axis.com, linux-efi@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-m32r-ja@ml.linux-m32r.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        openipmi-developer@lists.sourceforge.net,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-ia64@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-metag@vger.kernel.org, linux-mips@linux-mips.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-sh@vger.kernel.org, xen-devel@lists.xenproject.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 05/44] mfd: as3722: Drop reference to pm_power_off from
 devicetree bindings
Message-ID: <20141007163131.GE28835@roeck-us.net>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
 <1412659726-29957-6-git-send-email-linux@roeck-us.net>
 <543412F7.8040909@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543412F7.8040909@landley.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=0.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.5434156D.003C,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 34
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 32
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

On Tue, Oct 07, 2014 at 11:21:11AM -0500, Rob Landley wrote:
> On 10/07/14 00:28, Guenter Roeck wrote:
> > Devicetree bindings are supposed to be operating system independent
> > and should thus not describe how a specific functionality is implemented
> > in Linux.
> 
> So your argument is that linux/Documentation/devicetree/bindings should
> not be specific to Linux. Merely hosted in the Linux kernel source
> repository.
> 
> Well that's certainly a point of view.
> 
Not specifically my argument, really, and nothing new either. But, yes, I do
think that devicetree bindings descriptions should not include implementation
details, especially since those may change over time (as is the case here).

Thanks,
Guenter
