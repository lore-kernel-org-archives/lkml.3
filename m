Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030568Ab3DSMfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:35:42 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:45777 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S968302Ab3DSMfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:35:41 -0400
Date: Fri, 19 Apr 2013 13:35:13 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM64: kernel: compiling issue: need define readq and
 writeq for driver module using.
Message-ID: <20130419123513.GB18443@arm.com>
References: <51712975.8030104@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51712975.8030104@asianux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 12:24:37PM +0100, Chen Gang wrote:
> 
>   when compiling with allmodconfig, CONFIG_64BIT=y
>     the file drivers/base/regmap/regmap-mmio.c will use readq and writeq.
> 
>   so we need implement these functions.
> 
> BTW:
>   the coding style can not pass ./scripts/checkpatch.pl.
>   it seems better to provide additional patch for beautifying code.

If it complains about long lines, just ignore it. I wouldn't worry too
much about checkpatch.pl and coding style warnings ;)

> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Thanks.

-- 
Catalin
