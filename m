Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaBZNzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:55:42 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54906 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaBZNzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:55:41 -0500
Date: Wed, 26 Feb 2014 13:55:33 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        DCG_UPD_stlinux_kernel@list.st.com, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ahci: st: Add support for ST's SATA IP
Message-ID: <20140226135533.GN9195@lee--X1>
References: <1393328481-7251-1-git-send-email-lee.jones@linaro.org>
 <1393328481-7251-3-git-send-email-lee.jones@linaro.org>
 <20140225144141.GA26788@htj.dyndns.org>
 <20140226135108.GC17302@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140226135108.GC17302@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Cc: Tejun Heo <tj@kernel.org>
> > > Cc: linux-ide@vger.kernel.org
> > > Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > Applied to libata/for-3.15 w/ missing "\n" added to dev_err() in
> > st_ahci_suspend().
> 
> Reverted from libata/for-3.15 due to build failure.  Please drop
> ahci_platform_put_resource() calls.  ahci_platform now manages it
> through devres.

Ah, nice fixup.

I'll rebase onto your most recent tree and retest.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
