Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3HEM0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 08:26:33 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34264 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352Ab3HEM0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 08:26:32 -0400
Date: Mon, 5 Aug 2013 13:26:28 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, matt.fleming@intel.com,
        tony.luck@gmail.com, patches@linaro.org
Subject: Re: [PATCH v2 5/5] efi: x86: make efi_lookup_mapped_addr() a common
 function
Message-ID: <20130805122628.GS2515@console-pimps.org>
References: <1375462582-16423-1-git-send-email-leif.lindholm@linaro.org>
 <1375462582-16423-6-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375462582-16423-6-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Aug, at 05:56:22PM, Leif Lindholm wrote:
> efi_lookup_mapped_addr() is a handy utility for other platforms than
> x86. Move it from arch/x86 to drivers/firmware. Add memmap pointer
> to global efi structure, and initialise it on x86.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  arch/x86/platform/efi/efi.c |   30 ++----------------------------
>  drivers/firmware/efi/efi.c  |   32 ++++++++++++++++++++++++++++++++
>  include/linux/efi.h         |    1 +
>  3 files changed, 35 insertions(+), 28 deletions(-)

Looks good.

Tony, shout if you have any objection to modifying 'struct efi'.

-- 
Matt Fleming, Intel Open Source Technology Center
