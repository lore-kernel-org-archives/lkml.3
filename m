Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3H1HiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 03:38:05 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:63441 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab3H1HiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 03:38:03 -0400
Date: Wed, 28 Aug 2013 08:37:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        "'Ian Molton'" <ian.molton@collabora.co.uk>
Subject: Re: [PATCH 1/5] mfd: asic3: Remove .set_pwr() callback
Message-ID: <20130828073753.GC10210@lee--X1>
References: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
 <000001cea3b7$b9334250$2b99c6f0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000001cea3b7$b9334250$2b99c6f0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Since 3af9d15 "mmc: tmio-mmc: Remove .set_pwr() callback from
> > platform data", .set_pwr() callback is removed from platform data.
> > Thus, .set_pwr() is not used anymore. Also, this patch fixes
> > the following build error and warning.
> 
> I made this patch based on linux-next tree.
> 
> However, commit 3af9d15 "mmc: tmio-mmc: Remove .set_pwr()
> Callback from platform data" was merged to mmc-next tree.
> 
> Thus, how about merging these patchset through mmc-next tree
> instead of mfd tree?

Ouch! No, I think that patch should be removed from -next and for the
remainder to be place in the correct order before re-submission. It's
probably best to split "mmc: tmio-mmc: Remove .set_pwr() Callback from
platform data" into two patches, applying the removal of void (*set_pwr)
last.

Does that sound okay to you Chris?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
