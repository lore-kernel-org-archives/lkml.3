Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab3FZITw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:19:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46524 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3FZITt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:19:49 -0400
Date: Wed, 26 Jun 2013 09:19:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Jonathan Austin <jonathan.austin@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, linus.walleij@linaro.org,
        Will Deacon <will.deacon@arm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: amba-pl08x and 'get_signal' namespace collision/build error
Message-ID: <20130626081909.GD2718@n2100.arm.linux.org.uk>
References: <51C97F40.5030101@arm.com> <20130625184539.GB2718@n2100.arm.linux.org.uk> <20130626044842.GR23141@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626044842.GR23141@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 10:18:42AM +0530, Vinod Koul wrote:
> Yup. This is fixed in slave-dma tree by a patch from mark by renaming it.
> 
> This should not show in the -next tree

Except, that change probably is probably responsible for this new error:

drivers/dma/amba-pl08x.c: In function 'pl08x_request_mux':
drivers/dma/amba-pl08x.c:304:13: error: expected identifier before '(' token

