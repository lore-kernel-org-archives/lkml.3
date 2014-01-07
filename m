Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaAGXnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:43:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56939 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550AbaAGXnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:43:32 -0500
Date: Wed, 8 Jan 2014 00:43:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH v4 5/6] edac: Add support for Krait CPU cache error
 detection
Message-ID: <20140107234327.GH4164@pd.tnic>
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
 <1388434457-4194-6-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1388434457-4194-6-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 12:14:16PM -0800, Stephen Boyd wrote:
> Add support for the Krait CPU cache error detection. This is a
> simplified version of the code originally written by Stepan
> Moskovchenko[1] ported to the EDAC device framework.
> 
> [1] https://www.codeaurora.org/cgit/quic/la/kernel/msm/tree/arch/arm/mach-msm/cache_erp.c?h=msm-3.4
> 
> Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/edac/Kconfig      |   8 ++
>  drivers/edac/Makefile     |   2 +
>  drivers/edac/krait_edac.c | 346 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 356 insertions(+)
>  create mode 100644 drivers/edac/krait_edac.c

Looks nice and clean, applied.

So, patch 1/6 I'm taking anyway as it is a bugfix - for the others I'll
wait until 3/6 is cleared which way/how it goes.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
