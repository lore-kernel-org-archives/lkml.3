Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3K0Hks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 02:40:48 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:59640 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab3K0Hko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 02:40:44 -0500
Date: Wed, 27 Nov 2013 08:40:39 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Eunbong Song <eunb.song@samsung.com>
Cc: hskinnemoen@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] avr32: Kill CONFIG_MTD_PARTITIONS
Message-ID: <20131127074039.GA8295@samfundet.no>
References: <6858332.78861385513376432.JavaMail.weblogic@epml11>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6858332.78861385513376432.JavaMail.weblogic@epml11>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 27 Nov 2013 00:49:37 +0000 or thereabout, Eunbong Song wrote:
> 
> This patch removes CONFIG_MTD_PARTITIONS in config files for avr32.
>  Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.

Thank you for cleaning. I'll add this to my for-linus branch.

> Signed-off-by: Eunbong Song <eunb.song@samsung.com>
>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/configs/atngw100_defconfig              |    1 -
>  arch/avr32/configs/atngw100_evklcd100_defconfig    |    1 -
>  arch/avr32/configs/atngw100_evklcd101_defconfig    |    1 -
>  arch/avr32/configs/atngw100_mrmt_defconfig         |    1 -
>  arch/avr32/configs/atngw100mkii_defconfig          |    1 -
>  .../avr32/configs/atngw100mkii_evklcd100_defconfig |    1 -
>  .../avr32/configs/atngw100mkii_evklcd101_defconfig |    1 -
>  arch/avr32/configs/atstk1002_defconfig             |    1 -
>  arch/avr32/configs/atstk1003_defconfig             |    1 -
>  arch/avr32/configs/atstk1004_defconfig             |    1 -
>  arch/avr32/configs/atstk1006_defconfig             |    1 -
>  arch/avr32/configs/favr-32_defconfig               |    1 -
>  arch/avr32/configs/hammerhead_defconfig            |    1 -
>  arch/avr32/configs/merisc_defconfig                |    1 -
>  arch/avr32/configs/mimc200_defconfig               |    1 -
>  15 files changed, 0 insertions(+), 15 deletions(-)

<snipp diff>
