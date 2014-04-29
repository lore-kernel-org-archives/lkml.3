Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835AbaD2L1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:27:34 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39386 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933710AbaD2L1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:27:31 -0400
Date: Tue, 29 Apr 2014 12:27:20 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        catalin.marinas@arm.com, msalter@redhat.com, grant.likely@linaro.org,
        roy.franz@linaro.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 08/10] arm64: efi: add EFI stub
Message-ID: <20140429112720.GI26088@console-pimps.org>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
 <1398442154-19974-9-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398442154-19974-9-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr, at 05:09:12PM, Leif Lindholm wrote:
> From: Mark Salter <msalter@redhat.com>
> 
> This patch adds PE/COFF header fields to the start of the kernel
> Image so that it appears as an EFI application to UEFI firmware.
> An EFI stub is included to allow direct booting of the kernel
> Image.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> [Add support in PE/COFF header for signed images]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  arch/arm64/Kconfig              |    5 +-
>  arch/arm64/kernel/Makefile      |    4 +-
>  arch/arm64/kernel/efi-entry.S   |  109 +++++++++++++++++
>  arch/arm64/kernel/efi-stub.c    |   81 +++++++++++++
>  arch/arm64/kernel/head.S        |  112 ++++++++++++++++++
>  drivers/firmware/efi/arm-stub.c |  247 +++++++++++++++++++++++++++++++++++++++
>  6 files changed, 555 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm64/kernel/efi-entry.S
>  create mode 100644 arch/arm64/kernel/efi-stub.c
>  create mode 100644 drivers/firmware/efi/arm-stub.c

For the drivers/firmware/efi/arm-stub.c bits,

Acked-by: Matt Fleming <matt.fleming@intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center
