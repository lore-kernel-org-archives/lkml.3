Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaACOku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 09:40:50 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:39798 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704AbaACOkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 09:40:49 -0500
Date: Fri, 3 Jan 2014 14:40:44 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: hpa@zytor.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH tip/efi-kexec] x86: setup.c build fix
Message-ID: <20140103144044.GD2618@console-pimps.org>
References: <20140103035648.GA5291@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140103035648.GA5291@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Jan, at 11:56:49AM, Dave Young wrote:
> In case without CONFIG_EFI, there will be below build error:
>    arch/x86/built-in.o: In function `setup_arch':
> >> (.init.text+0x9dc): undefined reference to `parse_efi_setup'
> 
> Thus fix it by adding blank inline function in asm/efi.h
> Also remove an unused declaration for variable efi_data_len.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/include/asm/efi.h |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Thanks Dave. I picked up both patches.

-- 
Matt Fleming, Intel Open Source Technology Center
