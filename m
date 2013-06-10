Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3FJRpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:45:54 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:43489 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab3FJRpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:45:52 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Cc: J Keerthy <j-keerthy@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v1 0/3] PM / AVS: SmartReflex: use omap_sr * for class interfaces
References: <1369652964-14484-1-git-send-email-andrii.tseglytskyi@ti.com>
Date: Mon, 10 Jun 2013 10:45:48 -0700
In-Reply-To: <1369652964-14484-1-git-send-email-andrii.tseglytskyi@ti.com>
	(Andrii Tseglytskyi's message of "Mon, 27 May 2013 14:09:21 +0300")
Message-ID: <87vc5ldflf.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrii Tseglytskyi <andrii.tseglytskyi@ti.com> writes:

> SmartReflex driver interface is natively divided to two parts:
>
> - external SmartReflex interface
> - interface between SmartReflex driver and SmartReflex Class
>
> Functions which belong to AVS class interface can use
> struct omap_sr* instead of struct voltatedomain*, to provide a
> direct connection between SR driver and SR class. This allows
> us to optimize and not do additional lookups where none is
> required.
>
> Patches are based on:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> tag: v3.10-rc2
>
> Verified on OMAP4430. Boot - OK. SmartReflex registers debug dump - OK
>
> Available on GitHub:
> https://github.com/andriit/linux-omap-k3.8/commits/avs_sr_driver_std_class_interfaces_v01
>
> Andrii Tseglytskyi (3):
>   PM / AVS: SmartReflex: use omap_sr * for errgen interfaces
>   PM / AVS: SmartReflex: use omap_sr * for minmax interfaces
>   PM / AVS: SmartReflex: use omap_sr * for enable/disable interface
>
>  arch/arm/mach-omap2/smartreflex-class3.c |    8 ++--
>  drivers/power/avs/smartreflex.c          |   63 +++++++++++++++---------------
>  include/linux/power/smartreflex.h        |   10 ++---
>  3 files changed, 40 insertions(+), 41 deletions(-)

Thanks, queuing this series for v3.11.

Kevin
