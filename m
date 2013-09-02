Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab3IBKdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:33:16 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:42780 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758433Ab3IBKdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:33:14 -0400
Date: Mon, 2 Sep 2013 11:33:10 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-efi@vger.kernel.org, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>, linux-kernel@vger.kernel.org,
        Dave Martin <dave.martin@arm.com>, Mark Salter <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH V3 RFC 00/16] EFI stub for ARM
Message-ID: <20130902103310.GF28598@console-pimps.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
 <CAFECyb_OMY6eEbkbYTC4sE56Za0rC+KFNFRbGWb2ECEqhiKbTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFECyb_OMY6eEbkbYTC4sE56Za0rC+KFNFRbGWb2ECEqhiKbTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug, at 10:58:16AM, Roy Franz wrote:
> Hi Matt,
> 
>    Do you have any more feedback on the X86 and common code (patches
> 1-13) that needs to be addressed?  Mark Salter has a working ARM64 EFI
> stub implemented based on these patches, so the common code has now
> been tested with another architecture, and he has acked these patches.
> If the current patches are OK, can this be queued for 3.12? (and into
> linux-next, if appropriate)
> The ARM portion may take a little longer based on the EFI runtime
> services patch dependencies, but getting the common code merged would
> allow the ARM64 EFI stub work to go forward independently.
> 
> I can resend patches 1-13 as a new series of x86/common only changes
> if you would like.

I think resending the common patches as a new series, including Acked-by
and Reviewed-by tags, and after addressing Grant's comments is the best
idea.

We've missed the v3.12 merge window now, but we can certainly get these
into linux-next for some testing.

-- 
Matt Fleming, Intel Open Source Technology Center
