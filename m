Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaCFIzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:55:50 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:61578 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaCFIzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:55:48 -0500
Date: Thu, 6 Mar 2014 03:55:43 -0500
From: Matt Porter <matt.porter@linaro.org>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] ARM: bcm281xx: Consolidate code
Message-ID: <20140306085543.GE25092@beef>
References: <1393366666-28625-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393366666-28625-1-git-send-email-markus.mayer@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 02:17:42PM -0800, Markus Mayer wrote:
> This series contains some code consolidation for the Broadcom BCM281xx
> family of SoCs.
> 
> - Move kona_l2_cache_init() so other platforms can reuse it
> - Consolidate reboot code and move it to the board specific file
> - Sort header files in board file alphabetically
> - Rename the board_init() function to be board specific
> 
> Markus Mayer (4):
>   ARM: bcm281xx: Move kona_l2_cache_init() so it can be shared
>   ARM: bcm281xx: Consolidate reboot code
>   ARM: bcm281xx: Re-order hearder files
>   ARM: bcm281xx: Rename board_init() function

Applied to mach-bcm for-3.15/cleanup

-Matt
