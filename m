Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab3K2KhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:37:12 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:46820 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab3K2KhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:37:09 -0500
Date: Fri, 29 Nov 2013 10:36:49 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org,
        grant.likely@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        patches@linaro.org
Subject: Re: [PATCH V5 1/6] efi-stub.txt updates for ARM
Message-ID: <20131129103649.GA11775@console-pimps.org>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
 <1385595115-21488-2-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385595115-21488-2-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov, at 03:31:50PM, Roy Franz wrote:
> Update efi-stub.txt documentation to be more general
> and not x86 specific.  Add ARM only "dtb=" command
> line option description.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  Documentation/efi-stub.txt |   27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
> 

[...]

> -respectively.
> +respectively.  For ARM the EFI stub is implemented in
> +arch/arm/boot/compressed/efi-header.S and
> +arch/arm/boot/compressed/efi-stub.c.  EFI stub code that is shared
> +between architectures is in drivers/firmware/efi/efi-stub-helper.c.
  
No double spaces between full-stop and the beginning of a sentence
please. That convention isn't used anywhere else in this file.

> +For the ARM architecture, we also need to be able to provide a device
> +tree to the kernel.  This is done with the "dtb=" command line option,
> +and is process in the same manner as the "initrd=" option that is described

         ^^ processed ?

-- 
Matt Fleming, Intel Open Source Technology Center
