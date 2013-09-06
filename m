Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab3IFJe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 05:34:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53563 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3IFJe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 05:34:26 -0400
Date: Fri, 6 Sep 2013 10:28:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, nico@linaro.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Documentation: arm: early_ioremap/early_memremap
Message-ID: <20130906092853.GP6617@n2100.arm.linux.org.uk>
References: <1378459158-2145-1-git-send-email-leif.lindholm@linaro.org> <1378459158-2145-2-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378459158-2145-2-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 10:19:17AM +0100, Leif Lindholm wrote:
> +Any residual mappings will be overridden by subsequent kmap() calls (but do
> +use early_iounmap()).
> +
> +Specify 'early_ioremap_debug' on the kernel commandline for verbose output.
> +
> +SYNOPSIS
> +	#include <asm/io.h>

linux/io.h please.
