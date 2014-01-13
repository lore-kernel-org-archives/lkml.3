Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaAMPHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:07:40 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:39319 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619AbaAMPHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:07:39 -0500
Date: Mon, 13 Jan 2014 15:07:35 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org,
        grant.likely@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        patches@linaro.org
Subject: Re: [PATCH V6 0/8] Add ARM EFI stub
Message-ID: <20140113150735.GF3256@console-pimps.org>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan, at 08:30:09AM, Roy Franz wrote:
> This patch series adds EFI stub support for the ARM architecture.  The 
> stub for ARM is implemented in a similar manner to x86 in that it is a 
> shim layer between EFI and the normal zImage/bzImage boot process, and 
> that an image with the stub configured is bootable as both a zImage and 
> EFI application.  This patchset adds common code that is shared with
> the ARM64 EFI stub.
> 
> This patch depends on Leif Lindholm's ARM v7 runtime services patchset, which 
> in turn depends on Mark Salter's early_io_remap() patchset.  This EFI stub 
> patchset can be tested without those by simply modifying the Kconfig for 
> EFI_STUB to not depend on EFI.  The kernel will boot using the stub, 
> however no EFI support will be available in the kernel.
> 
> I have addressed all the feedback I have recieved to date, and I am hoping 
> that this patchset is acceptable for merging into 3.14.  It has been 
> functionally stable for some time, and provides useful functionality.  
> Further consolidation of the ARM/ARM64 stubs planned as part of the 
> ongoing development of the stubs and supporting tools for both 
> architectures (getting the FDT from a UEFI configuration table, using UEFI 
> memory map instead of FDT for memory description.) 

Is this going to Linus via one of the ARM maintainer trees?

-- 
Matt Fleming, Intel Open Source Technology Center
