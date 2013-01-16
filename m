Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3APLoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 06:44:16 -0500
Received: from mail.hostpark.net ([212.243.197.30]:37909 "EHLO
	mail.hostpark.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3APLoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 06:44:12 -0500
Message-ID: <50F69289.8060401@mpl.ch>
Date: Wed, 16 Jan 2013 12:44:09 +0100
From: Stefan Peter <s.peter@mpl.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, andrew@lunn.ch, dwmw2@infradead.org,
        jm@lentin.co.uk, arnd@arndb.de, sebastian.hesselbarth@googlemail.com,
        iwamatsu@nigauri.org, artem.bityutskiy@linux.intel.com,
        wfp5p@virginia.edu, gregkh@linuxfoundation.org,
        broonie@opensource.wolfsonmicro.com, mchehab@redhat.com,
        nico@linaro.org
Subject: Re: [PATCH 3/4] Enable ecc-mode selection in the driver
References: <cover.1358242644.git.s.peter@mpl.ch> <2d08c4c072fd4922a6056362adb96a455307d583.1358242644.git.s.peter@mpl.ch> <20130115123307.GA13433@titan.lakedaemon.net>
In-Reply-To: <20130115123307.GA13433@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason

on 15.01.2013 13:33, Jason Cooper wrote:
> Stefan,
> 
> This is a good-looking patch series, nice and small!  A few comments:
> 
> On Tue, Jan 15, 2013 at 01:13:12PM +0100, Stefan Peter wrote:
>> In order to be able to use the ecc-mode, add the bch module to the default
>> settings for the kirwood boards and enable the activation in orin-nand.c
> 
> s/orin-nand/orion-nand/

Will fix.

> 
>>
>> Signed-off-by: Stefan Peter <s.peter@mpl.ch>
>> ---
>> diff --git a/arch/arm/configs/kirkwood_defconfig b/arch/arm/configs/kirkwood_defconfig
>> index 93f3794..4a9d3f7 100644
>> --- a/arch/arm/configs/kirkwood_defconfig
>> +++ b/arch/arm/configs/kirkwood_defconfig
>> @@ -84,6 +84,7 @@ CONFIG_MTD_CFI_STAA=y
>>  CONFIG_MTD_PHYSMAP=y
>>  CONFIG_MTD_M25P80=y
>>  CONFIG_MTD_NAND=y
>> +CONFIG_MTD_NAND_ECC_BCH=y
>>  CONFIG_MTD_NAND_ORION=y
>>  CONFIG_BLK_DEV_LOOP=y
>>  # CONFIG_SCSI_PROC_FS is not set
> 
> Please make the defconfig change a separate patch.

Will do.

> 
> As a general note (this series shouldn't be a problem), please sort the
> series so that you add the driver feature first, then enable it in
> defconfig, then use it in DT.  This way, a future bisection won't run
> into any nasty surprises, other than what they're looking for. ;-)

Will do.

Thank you very much for your review.

Stefan Peter
-- 
MPL AG, Switzerland                     http://www.mpl.ch
Tel. +41 (0)56 483 34 34          Fax: +41(0)56 493 30 20
