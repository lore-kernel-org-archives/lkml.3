Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaEIHKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:10:08 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:40614 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaEIHKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:10:07 -0400
MIME-Version: 1.0
In-Reply-To: <536BDB88.8090106@ti.com>
References: <1398755224-7530-1-git-send-email-prabhakar.csengg@gmail.com> <536BDB88.8090106@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 9 May 2014 12:39:35 +0530
Message-ID: <CA+V-a8s_vjvcX_BpLeg0tnBQx4+n2voQo_dz+EA_ZETTV_exyg@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: configs: drop CONFIG_COMMON_CLK_DEBUG
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Olof Johansson <olof@lixom.net>, Tony Prisk <linux@prisktech.co.nz>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh,

On Fri, May 9, 2014 at 1:01 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> On Tuesday 29 April 2014 03:07 AM, Lad Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> this patch removes COMMON_CLK_DEBUG config option
>> from defconfig file as this config option is obsolete.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  Changes for v2:
>>  a> Dropped imx defconfig files as suggested by Shawn.
>>
>
>>  arch/arm/configs/keystone_defconfig     |    1 -
> Am picking the keystone part from this patch. Thanks.
> You might want split this patch so that others can pick it
> up
>
Thanks for picking it up.

Thanks,
--Prabhakar Lad
