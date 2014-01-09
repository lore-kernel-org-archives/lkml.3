Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaAILeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:34:22 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27288 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaAILeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:34:15 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-12-52ce89351286
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Roger Quadros <rogerq@ti.com>
Cc: tj@kernel.org, sergei.shtylyov@cogentembedded.com, kishon@ti.com,
        hdegoede@redhat.com, arnd@arndb.de, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 0/3] ata: ahci_platform: Add PHY support and OMAP support
Date: Thu, 09 Jan 2014 12:33:54 +0100
Message-id: <1389284177.iKaZgY0Ov4@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1389264962-22858-1-git-send-email-rogerq@ti.com>
References: <1389264962-22858-1-git-send-email-rogerq@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAV3TznNBBm/Palj8nXSM3WL+kXOs
	Fm+OT2eyuPC0h83i2I5HTBaXd81hs+h5pGVxZtUtdotfy48yOnB6/P41idHjwdT/TB6bVnWy
	ebzfd5XN4/iN7UwenzfJBbBFcdmkpOZklqUW6dslcGVsWONYcIy94uWMCUwNjB9Zuxg5OSQE
	TCRerLzEBmGLSVy4tx7I5uIQEljEKNG6dS8rhNPCJHF+42mwKjYBK4mJ7asYQWwRAUWJeysh
	OpgFDjJK9F2BKBIWCJCYsvQmC4jNIqAqcevdbmYQm1dAR+L2/slMILaogKfEju0rweo5Bewk
	Xu/+ATZUSMBWYv6zXWwQ9YISPybfA5vDLCAvsW//VFYIW0dif+s0tgmMArOQlM1CUjYLSdkC
	RuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEx8ExqB+PKBotDjAIcjEo8vCuKzwYJsSaW
	FVfmHmKU4GBWEuGd2nguSIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILU
	IpgsEwenVAPjoWY2btOLTV/vpfjKH3L5d5z5/I4/1hNFHl/pVcg8HX35Qeu0RF7F36JbtL0n
	lc5y3/aJIdTqi6nQ2vsNW3L6G5qeLlDYc+CiTb71Gr8NNf7blp5acv7zunMe890z8veFRAbu
	8n8f3H/a/HP2r0+36+xNuCQWvA7Q4mxMWK7++e7Um70PPneuUWIpzkg01GIuKk4EAEvT7+J9	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, January 09, 2014 04:25:59 PM Roger Quadros wrote:
> Hi,
> 
> Some platforms have a PHY hooked up to the SATA controller.
> The PHY needs to be initialized and powered up for SATA to work.
> We do that using the Generic PHY framework in PATCH 2.
> 
> In order to support SATA on the OMAP platforms we need to runtime
> resume the device before use. PATCH 3 takes care of that.
> 
> PATCH 1 just updates the compatible list in the DT binding document.
> 
> Changelog:
> v4:
> - Tackle error conditions while using PHY framework APIs.
> 
> v3:
> - Addressed review comments and rebased on 3.13-rc7
> - DT binding update moved to new patch.
> 
> v2:
> - got rid of Texas Instruments SATA wrapper driver
> - adressed review comments

Thanks for fixing it.

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

