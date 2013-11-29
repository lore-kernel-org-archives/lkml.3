Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab3K2QAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 11:00:42 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:45773 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab3K2QAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 11:00:41 -0500
Date: Fri, 29 Nov 2013 16:00:32 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [PATCH 3/5] MFD: twl6040: reg_defaults support for regmap
Message-ID: <20131129160032.GC26982@lee--X1>
References: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
 <1385733827-19831-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385733827-19831-4-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Nov 2013, Peter Ujfalusi wrote:

> Add reg_defaults to regmap and at the same time implement proper power state
> handling with using regcache_cache_only(), regcache_sync() and
> regcache_mark_dirty().
> This will make sure that we do not need to do restore operations in child
> drivers anymore.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/mfd/twl6040.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 89 insertions(+), 3 deletions(-)

The code looks fine to me (me = !regmap expert), so with Mark's Ack I
will apply.

Mark, is an immutable branch required for this patch?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
