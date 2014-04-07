Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaDGNXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:23:04 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:43695 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbaDGNXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:23:01 -0400
Date: Mon, 7 Apr 2014 14:22:51 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, matt.fleming@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Non-ARM-specific EFI patches needed for ARM ports
Message-ID: <20140407132251.GH5222@console-pimps.org>
References: <1396614350-20889-1-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396614350-20889-1-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Apr, at 01:25:45PM, Leif Lindholm wrote:
> This is the set of patches from the arm/arm64 UEFI support that are not
> in fact architecture specific. This set depends on other EFI patches
> already in linux-next.
> 
> H. Peter Anvin (1):
>   efi: x86: Improve cmdline conversion
> 
> Leif Lindholm (1):
>   efi: efi-stub-helper cleanup
> 
> Mark Salter (1):
>   efi: create memory map iteration helper
> 
> Roy Franz (2):
>   efi: Add shared printk wrapper for consistent prefixing
>   efi: Add get_dram_base() helper function
> 
>  arch/x86/boot/compressed/eboot.c       |    3 +-
>  drivers/firmware/efi/efi-stub-helper.c |  148 +++++++++++++++++++++++---------
>  include/linux/efi.h                    |    6 ++
>  3 files changed, 116 insertions(+), 41 deletions(-)

Thanks Leif, I'll pick these up once the comments to PATCH 3 and PATCH 4
(from Joe) are addressed. Otherwise they look fine.

-- 
Matt Fleming, Intel Open Source Technology Center
