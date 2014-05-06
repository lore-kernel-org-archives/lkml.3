Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbaEFIoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:44:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46933 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934333AbaEFIoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:44:15 -0400
Message-ID: <5368A0D9.60500@ti.com>
Date: Tue, 6 May 2014 11:44:09 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <balbi@ti.com>,
        <balajitk@ti.com>, <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 0/4] ARM: OMAP: SATA support for OMAP5 & DRA7
References: <1398274237-24510-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1398274237-24510-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 04/23/2014 08:30 PM, Roger Quadros wrote:
> Hi Tony,
> 
> These are the pending HWMOD and DTS patches to get SATA working
> on OMAP5-uevm and DRA7-evm. Please queue them for -next. Thanks.

gentle reminder. Thanks.

cheers,
-roger

> 
> ---
> Balaji T K (2):
>   ARM: dts: omap5: add sata node
>   ARM: dts: dra7: add OCP2SCP3 and SATA nodes
> 
> Keshava Munegowda (1):
>   ARM: OMAP5: hwmod: Add ocp2scp3 and sata hwmods
> 
> Nikhil Devshatwar (1):
>   ARM: DRA7: hwmod: Add ocp2scp3 and sata hwmods
> 
>  arch/arm/boot/dts/dra7.dtsi                | 39 ++++++++++++++++
>  arch/arm/boot/dts/omap5.dtsi               | 40 ++++++++++++++++
>  arch/arm/mach-omap2/omap_hwmod_54xx_data.c | 73 ++++++++++++++++++++++++++++++
>  arch/arm/mach-omap2/omap_hwmod_7xx_data.c  | 31 +++++++++++--
>  4 files changed, 178 insertions(+), 5 deletions(-)
> 

