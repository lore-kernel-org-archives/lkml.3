Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3EUNSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:18:12 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:59191 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751724Ab3EUNSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:18:11 -0400
Date: Tue, 21 May 2013 14:17:34 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: compiling issue for allmodconfig, need
 "asm/parport.h" by "drivers/parport/parport_pc.c"
Message-ID: <20130521131734.GD27002@arm.com>
References: <5177551D.8090007@asianux.com>
 <20130424082237.GA23397@arm.com>
 <5177B1F0.10106@asianux.com>
 <20130424102327.GF21850@mudshark.cambridge.arm.com>
 <5177BAD0.9000500@asianux.com>
 <20130424110511.GK23397@arm.com>
 <5199A453.4080402@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5199A453.4080402@asianux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 05:19:31AM +0100, Chen Gang wrote:
> 
> Need add the default file in 'asm/Kbuild' just like arm has done.
> 
> The build command is:
>   make EXTRA_CFLAGS=-W ARCH=arm64 allmodconfig
>   make EXTRA_CFLAGS=-W ARCH=arm64 menuconfig
>     set "aarch64-linux-gnu-" as cross compiling prefix.
>   make EXTRA_CFLAGS=-W ARCH=arm64
> 
> The related error:
>   drivers/parport/parport_pc.c:67:25: fatal error: asm/parport.h: No such file or directory

As I don't see when we'd need this driver, you can probably change the
Kconfig entry (similar to the VGA_CONSOLE one).

Thanks.

-- 
Catalin
