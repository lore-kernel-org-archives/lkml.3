Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaAXCNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 21:13:30 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:32961 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaAXCN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 21:13:27 -0500
Date: Thu, 23 Jan 2014 18:11:32 -0800
From: Olof Johansson <olof@lixom.net>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, arm@kernel.org, linux@arm.linux.org.uk
Subject: Re: [PATCH] ARM: moxart: DT fixups
Message-ID: <20140124021132.GB17877@quad.lixom.net>
References: <1390317973-24110-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390317973-24110-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 04:26:13PM +0100, Jonas Jensen wrote:
> Change DT files to remain coherent with changes in
> accompanying drivers.
> 
> 1. replace "sdhci" with "mmc"
> 2. add bus-width property to mmc node
> 3. drop device_type property
> 4. replace "mac@" with "ethernet@"
> 5. replace CONFIG_MMC_SDHCI_MOXART with CONFIG_MMC_MOXART
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Applies on top of:
>     
>     "[PATCH] ARM: moxart: move fixed rate clock child node to board level dts"
>     http://lists.infradead.org/pipermail/linux-arm-kernel/2014-January/226141.html
>     
>     Applies to next-20140121

Since the prereqs for this patch are in different branches right now, I'll have
to apply it after the merges have been done by Linus. I'll include it in
a batch of fixes later on -- remind me if we forget.


-Olof
