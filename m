Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaDCVEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 17:04:55 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:59094 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568AbaDCVEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 17:04:54 -0400
Date: Thu, 3 Apr 2014 22:04:44 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Daniel McLellan <daniel.mclellan@gmail.com>
Cc: linux-kernel@vger.kernel.org, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: eboot.c regression allows boot, from v3.7 on- no boot with UEFI,
 only legacy, bisect results
Message-ID: <20140403210444.GB5222@console-pimps.org>
References: <CAEigmK-pY+9XF4V-KRZrbiO8GY5Fs6scE+Ehm1zc5T8V2RiB9g@mail.gmail.com>
 <20140403210342.GA5222@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403210342.GA5222@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding addresses for real this time... )

On Thu, 03 Apr, at 10:03:42PM, Matt Fleming wrote:
> (Adding linux-efi and correct Matthew's address)
> 
> On Fri, 28 Mar, at 04:08:36PM, Daniel McLellan wrote:
> > System: Hewlett-Packard product: HP EliteBook 2570p
> > CPU~Dual core Intel Core i7-3520M CPU (-HT-MCP-)
> > Kernel: 3.12.4-2-hplove x86_64 (64 bit) Desktop: Enlightenment 0.18.99.18202
> > Distro: Arch Linux
> > 
> > 
> > I believe this issue is common to only a few iterations of ivy bridge
> > 
> > https://bbs.archlinux.org/viewtopic.php?id=156670
> > https://bugs.archlinux.org/task/33745?project=1
> > 
> > I had been patching eboot.c to v3.7 with the attached
> > efi_hp_boot.patch, but due to the recent changes in eboot.c (in v3.13)
> > I decided to bisect, and identified the following:
> > 
> > # first bad commit: [dd5fc854de5fd37adfcef8a366cd21a55aa01d3d] EFI:
> > Stash ROMs if they're not in the PCI BAR
> > 
> > My next step is diffing the eboot.c from v3.13.
> > 
> > or would a better path be to check for ivy bridge?
> 
> Daniel, could you try booting a recent kernel, without your patch
> applied and with the earlyprintk=efi,keep kernel parameter.
> 
> Meanwhile I'm going to try and reproduce this error.
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center

-- 
Matt Fleming, Intel Open Source Technology Center
