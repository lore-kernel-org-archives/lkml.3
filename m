Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3ARTIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:08:15 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:46221 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3ARTIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:08:13 -0500
Date: Fri, 18 Jan 2013 20:08:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2 31/76] ARC: Build system: Makefiles, Kconfig, Linker
	script
Message-ID: <20130118190811.GA14441@merkur.ravnborg.org>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-32-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358511930-7424-32-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  arch/arc/include/asm/vmlinux.lds.h |   12 ++

I see no reason for this file?

> --- /dev/null
> +++ b/arch/arc/include/asm/vmlinux.lds.h
> @@ -0,0 +1,12 @@
> +/*
> + * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __ASM_VMLINUX_LDS_H__
> +#define __ASM_VMLINUX_LDS_H__
> +
> +#endif

It is empty.
Only sh provide one today (which is not empty).

	Sam
