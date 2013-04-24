Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449Ab3DXKmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:42:52 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:46928 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758432Ab3DXKmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:42:51 -0400
Date: Wed, 24 Apr 2013 11:42:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arm64: compiling issue, need add include/asm/vga.h
 file
Message-ID: <20130424104231.GJ23397@arm.com>
References: <5177551D.8090007@asianux.com>
 <20130424082237.GA23397@arm.com>
 <5177B1F0.10106@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5177B1F0.10106@asianux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 11:20:32AM +0100, Chen Gang wrote:
> For compiling with allmodconfig, need vga.h file, so generate it which
> just only include the asm-generic one.
> 
> It is firstly used by drivers/gpu/drm/drm_irq.c.
> 
> The related error:
> include/video/vga.h:22:21: fatal error: asm/vga.h: No such file or directory
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arm64/include/asm/vga.h |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm64/include/asm/vga.h

As Will said, please use asm/Kbuild.

> diff --git a/arch/arm64/include/asm/vga.h b/arch/arm64/include/asm/vga.h
> new file mode 100644
> index 0000000..1c49d51
> --- /dev/null
> +++ b/arch/arm64/include/asm/vga.h
> @@ -0,0 +1,21 @@
> +/*
> + * Copyright (C) 2012 ARM Ltd.

ARM copyright? You either work for ARM or there is a copyright
assignment between you and ARM ;)

-- 
Catalin
