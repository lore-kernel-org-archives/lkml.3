Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902AbaD2LZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:25:09 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39349 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933773AbaD2LZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:25:05 -0400
Date: Tue, 29 Apr 2014 12:24:59 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        catalin.marinas@arm.com, msalter@redhat.com, grant.likely@linaro.org,
        roy.franz@linaro.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 05/10] efi: Add shared FDT related functions for
 ARM/ARM64
Message-ID: <20140429112459.GH26088@console-pimps.org>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
 <1398442154-19974-6-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398442154-19974-6-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr, at 05:09:09PM, Leif Lindholm wrote:
> From: Roy Franz <roy.franz@linaro.org>
> 
> Both ARM and ARM64 stubs will update the device tree that they pass to
> the kernel.  In both cases they primarily need to add the same UEFI
> related information, so the function can be shared.  Create a new FDT
> related file for this to avoid use of architecture #ifdefs in
> efi-stub-helper.c.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> [ Fixed memory node deletion code. ]
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> Acked-by: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/firmware/efi/fdt.c |  285 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h        |    3 +
>  2 files changed, 288 insertions(+)
>  create mode 100644 drivers/firmware/efi/fdt.c

Acked-by: Matt Fleming <matt.fleming@intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center
