Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab3FZNcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:32:23 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38012 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368Ab3FZNcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:32:21 -0400
Date: Wed, 26 Jun 2013 14:32:17 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, hpa@linux.intel.com, tglx@linutronix.de,
        matt.fleming@intel.com
Subject: Re: [PATCH 2/4] x86: efi: break efi_lookup_mapped_addr out to
 generic code
Message-ID: <20130626133217.GO22026@console-pimps.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-3-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372183863-11333-3-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun, at 07:11:01PM, Leif Lindholm wrote:
> efi_lookup_mapped_addr is a handy helper function for translating
> a physical address to the corresponding virtual one by scanning
> through memmap.map.
> 
> This patch breaks it out into a new file for use elsewhere.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  arch/x86/platform/efi/efi.c       |   28 ----------------------------
>  drivers/firmware/efi/Makefile     |    2 +-
>  drivers/firmware/efi/efi-helper.c |   33 +++++++++++++++++++++++++++++++++
>  3 files changed, 34 insertions(+), 29 deletions(-)
>  create mode 100644 drivers/firmware/efi/efi-helper.c

I'm not sure this function needs its own file. drivers/firmware/efi/efi.c
is a suitable place for this.

-- 
Matt Fleming, Intel Open Source Technology Center
