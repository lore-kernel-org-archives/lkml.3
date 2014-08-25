Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbaHYIZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:25:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34962 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754571AbaHYIY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:24:59 -0400
Date: Mon, 25 Aug 2014 10:24:45 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: mathieu.poirier@linaro.org
Cc: linus.walleij@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        00regkh@linuxfoundation.org, daniel.thompson@linaro.org,
        robbelibobban@gmail.com, Al.Grant@arm.com, patches@linaro.org,
        marcin.jabrzyk@gmail.com, linux-kernel@vger.kernel.org,
        panchaxari.prasannamurthy@linaro.org, r.sengupta@samsung.com,
        Tony.Armitstead@arm.com, linux-arm-kernel@lists.infradead.org,
        james.king@linaro.org, pratikp@codeaurora.org, varshney@ti.com,
        jonas.svennebring@avagotech.com, kaixu.xia@linaro.org
Subject: Re: [PATCH 01/11 v4] coresight: add CoreSight core layer framework
Message-ID: <20140825102445.1ff19682@free-electrons.com>
In-Reply-To: <1408554231-24321-2-git-send-email-mathieu.poirier@linaro.org>
References: <1408554231-24321-1-git-send-email-mathieu.poirier@linaro.org>
	<1408554231-24321-2-git-send-email-mathieu.poirier@linaro.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, 20 Aug 2014 11:03:41 -0600, mathieu.poirier@linaro.org wrote:

> diff --git a/drivers/coresight/Makefile b/drivers/coresight/Makefile
> new file mode 100644
> index 0000000..fef87bc
> --- /dev/null
> +++ b/drivers/coresight/Makefile
> @@ -0,0 +1,9 @@
> +#
> +# Makefile for CoreSight drivers.
> +#
> +obj-$(CONFIG_CORESIGHT) += coresight.o
> +obj-$(CONFIG_OF) += of_coresight.o
> +obj-$(CONFIG_CORESIGHT_LINKS_AND_SINKS) += coresight-tmc.o coresight-tpiu.o \
> +					   coresight-etb10.o coresight-funnel.o \
> +					   coresight-replicator.o
> +obj-$(CONFIG_CORESIGHT_SOURCE_ETM3X) += coresight-etm3x.o coresight-etm-cp14.o

I believe this is a bit messed up with PATCH 02/11. Here you're adding
references to many files that aren't part of this patch, but are added
in subsequent patches. PATCH 02/11 removes those lines and replaces
them by the correct values. Surely an interactive rebase conflict that
was not solved properly.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
