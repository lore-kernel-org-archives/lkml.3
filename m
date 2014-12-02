Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaLBJbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:31:38 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54986 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaLBJbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:31:35 -0500
MIME-Version: 1.0
In-Reply-To: <2e3f47e730975654f9b6c888a07db6c3f886b892.1417438852.git.michal.simek@xilinx.com>
References: <2e3f47e730975654f9b6c888a07db6c3f886b892.1417438852.git.michal.simek@xilinx.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 2 Dec 2014 09:31:04 +0000
Message-ID: <CA+V-a8vw2d8H=Qx99M4oXqUatt5wmePVW82ARdMcWLEVLXbZJw@mail.gmail.com>
Subject: Re: [PATCH v1] lib/genalloc.c: Export devm_gen_pool_create for modules
To: Michal Simek <michal.simek@xilinx.com>
Cc: LKML <linux-kernel@vger.kernel.org>, monstr@monstr.eu,
        Andrew Morton <akpm@linux-foundation.org>,
        Laura Abbott <lauraa@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Thanks for the patch.

On Mon, Dec 1, 2014 at 1:00 PM, Michal Simek <michal.simek@xilinx.com> wrote:
> Modules can use this function for creating pool.
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>
> I am pushing Zynq OCMC driver which is using this function.
>
> ---
>  lib/genalloc.c | 1 +
>  1 file changed, 1 insertion(+)
>
don’t you need to add an entry in include/linux/genalloc.h ?

Thanks,
--Prabhakar Lad

> diff --git a/lib/genalloc.c b/lib/genalloc.c
> index cce4dd68c40d..2e65d206b01c 100644
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -598,6 +598,7 @@ struct gen_pool *devm_gen_pool_create(struct device *dev, int min_alloc_order,
>
>         return pool;
>  }
> +EXPORT_SYMBOL(devm_gen_pool_create);
>
>  /**
>   * dev_get_gen_pool - Obtain the gen_pool (if any) for a device
> --
> 1.8.2.3
>
