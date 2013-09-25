Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3IYMB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:01:29 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:51504 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755198Ab3IYMB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:01:27 -0400
Date: Wed, 25 Sep 2013 13:01:24 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, leif.lindholm@linaro.org,
        grant.likely@linaro.org, msalter@redhat.com
Subject: Re: [PATCH 08/18] Generalize relocate_kernel() for use by other
 architectures.
Message-ID: <20130925120124.GF21381@console-pimps.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
 <1379889942-3135-9-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379889942-3135-9-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Sep, at 03:45:32PM, Roy Franz wrote:
> Rename relocate_kernel() to efi_relocate_kernel(), and take
> parameters rather than x86 specific structure.  Add max_addr
> argument as for ARM we have some address constraints that we
> need to enforce when relocating the kernel.  Add alloc_size
> parameter for use by ARM64 which uses an uncompressed kernel,
> and needs to allocate space for BSS.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |   10 ++++-
>  drivers/firmware/efi/efi-stub-helper.c |   72 ++++++++++++++++++++++----------
>  2 files changed, 59 insertions(+), 23 deletions(-)

[...]

I fixed up these multi-line comments too.

-- 
Matt Fleming, Intel Open Source Technology Center
