Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3KYWZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:25:01 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52581 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab3KYWY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:24:59 -0500
Message-ID: <5293CE23.5080205@ti.com>
Date: Mon, 25 Nov 2013 16:24:35 -0600
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] AES/DES hwmod data and dmtimer fix
References: <1385415876-12387-1-git-send-email-joelf@ti.com> <20131125221232.GV10023@atomide.com>
In-Reply-To: <20131125221232.GV10023@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 04:12 PM, Tony Lindgren wrote:
> * Joel Fernandes <joelf@ti.com> [131125 13:46]:
>> Here are patches adding hwmod for AES/DES crypto modules for OMAP4, DRA7 SoCs.
>>
>> Also included is a fix that disables POSTED mode when dmtimer is requested.
>>
>> Joel Fernandes (7):
>>   ARM: OMAP: hwmod: Add SYSC offsets for AES IP
>>   ARM: DRA7xx: hwmod: Add hwmod data for DES IP
>>   ARM: DRA7xx: hwmod: Add hwmod data for AES IP
>>   ARM: OMAP4: hwmod: Add hwmod data for AES IP
>>   ARM: OMAP4: hwmod: add hwmod data for DES IP
>>   ARM: OMAP: Disable POSTED mode for errata i103 and i767
>>   OMAP: AM33xx: hwmod: Correct AES module SYSC type
>>
>>  arch/arm/mach-omap2/omap_hwmod.h                   |  11 +++
>>  .../mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c |   1 +
>>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c         | 101 +++++++++++++++++++++
>>  arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  78 ++++++++++++++++
>>  arch/arm/mach-omap2/omap_hwmod_common_data.c       |  10 ++
>>  arch/arm/plat-omap/include/plat/dmtimer.h          |   5 +-
>>  6 files changed, 205 insertions(+), 1 deletion(-)
> 
> To me it seems we should wait on these until we have the clocks
> coming from device tree. That leaves out some parts of this
> patchset.
> 

Ok, sure. Let me see which parts can go in now till DT entries are available. If
it doesn't make sense to apply these now, I'll revise and post them again later
once clock data is merged.

thanks,

-Joel
