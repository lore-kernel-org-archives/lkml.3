Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab3A2QLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:11:12 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:41188 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3A2QLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:11:09 -0500
Message-ID: <5107F499.2050608@gmail.com>
Date: Tue, 29 Jan 2013 10:11:05 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
CC: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk
Subject: Re: [RFC PATCH 0/2] ARM: update cpuinfo to print CPU model name
References: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com>
In-Reply-To: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 09:54 AM, Ruslan Bilovol wrote:
> Hi,
> 
> The following patches update cpuinfo to print CPU
> model name for ARM. First patch exactly makes needed
> changes for ARM architecture.
> Second patch adds this ability to OMAP4 SoCs.
> 
> This adds a common approach to show SoC name.
> 
> Looks like there were few attempts to do similar
> changes to cpuinfo without any luck.

Care to point out how your solution is different from those or addresses
the issues with them.

Assuming we want to do this, I think this information should come from
DeviceTree. OMAP may have this in a register, but others don't.

Rob

> 
> So - comments are welcome
> 
> Ruslan Bilovol (2):
>   ARM: kernel: update cpuinfo to print CPU model name
>   ARM: OMAP4: setup CPU model name during ID initialisation
> 
>  arch/arm/include/asm/setup.h |    1 +
>  arch/arm/kernel/setup.c      |   10 ++++++++++
>  arch/arm/mach-omap2/id.c     |   18 ++++++++++++++++--
>  3 files changed, 27 insertions(+), 2 deletions(-)
> 

