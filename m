Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaINPSx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 11:18:53 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:34600 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaINPSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 11:18:51 -0400
Date: Sun, 14 Sep 2014 16:18:47 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Glenn P. Williamson" <glenn.p.williamson@intel.com>
Subject: Re: [PATCH 6/6] x86/efi: introduce EFI_BOOT_SERVICES_WARN
Message-ID: <20140914151847.GK18582@console-pimps.org>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
 <1410633376-8822-7-git-send-email-ricardo.neri-calderon@linux.intel.com>
 <20140914000130.GC18296@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140914000130.GC18296@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Sep, at 02:01:30AM, Borislav Petkov wrote:
> On Sat, Sep 13, 2014 at 11:36:16AM -0700, Ricardo Neri wrote:
> > Being more verbose about this kind of illegal access from the firmware
> > increases the likelihood of this kind firmware bugs to be fixed.
> 
> I sincerely hope you're right and, more importantly, how do we make sure
> those warnings get seen in time for a fix to even be possible..?

Some firmware teams do run Linux as part of their validation process,
and have been known to pay attention to the kernel boot messages. So
there's definitely hope there.

But we are also taking a more active approach with the Linux UEFI
Validation project [1], where we consume these kinds of error messages
and turn them into explicit test passes/failures.

We've been attending the UEFI plugfests and trying to work directly with
firmware engineers to bridge that communication gap between firmware and
OS, so that we can fix these kinds of bugs before they appear in the
wild.

[1] - https://01.org/linux-uefi-validation

-- 
Matt Fleming, Intel Open Source Technology Center
