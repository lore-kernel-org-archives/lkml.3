Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaKJLAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:00:30 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:43772 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaKJLA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:00:29 -0500
Date: Mon, 10 Nov 2014 11:00:22 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v2 0/3] regulator: max77686/802: Cleanup
Message-ID: <20141110110022.GX21424@x1>
References: <1415180871-25293-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415180871-25293-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2014, Krzysztof Kozlowski wrote:

> Hi,
> 
> 
> Changes since v1
> ================
> 1. Rebase on next-20141105, now it should apply cleanly to regulator
>    tree.
> 2. Remove first 3 patches, applied by Mark.
> 
> 
> Description
> ===========
> Previously this patchset was part of adding GPIO to max77686
> regulator driver [1]. I split it but the goal is the same:
> cleanup and simplify the regulator drivers by removing obsolete
> board file support so adding new features would be easier.
> 
> The patchset removes board file support from regulator drivers
> incrementally and in a bisect-friendly way. Thus MFD driver is
> updated at the end.
> 
> Everything should be pulled at once (preferrably regulator tree).
> Rebased on next-20141105.

I'm happy for that to happen, so long as Mark sends me a tagged commit
to pull from.

> The changes on max77802 were not tested.
> I am kindly asking for testing it because I don't have the board
> with Maxim 77802.
> 
> 
> [1] [PATCH v3 00/14] regulator: max77686: Add GPIO control
>     https://lkml.org/lkml/2014/10/30/270
> 
> 
> Best regards,
> Krzysztof Kozlowski
> 
> 
> Krzysztof Kozlowski (3):
>   regulator: max77802: Remove support for board files
>   regulator: max77686: Remove support for board files
>   mfd: max77686/802: Remove support for board files
> 
>  drivers/mfd/Kconfig                  |  1 +
>  drivers/mfd/max77686.c               | 23 ---------
>  drivers/regulator/max77686.c         | 91 ++++++++---------------------------
>  drivers/regulator/max77802.c         | 92 ++++++++----------------------------
>  include/linux/mfd/max77686-private.h |  1 -
>  include/linux/mfd/max77686.h         | 28 -----------
>  6 files changed, 39 insertions(+), 197 deletions(-)
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
