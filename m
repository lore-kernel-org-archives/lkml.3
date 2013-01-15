Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3AOIUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 03:20:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59391 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab3AOIUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 03:20:52 -0500
Message-ID: <50F51162.1080606@ti.com>
Date: Tue, 15 Jan 2013 09:20:50 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH 00/10] MFD: twl-core: Cleanup part 2 for 3.9
References: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On 12/31/2012 12:09 PM, Peter Ujfalusi wrote:
> Hello,
> 
> Second part of the cleanup of twl-core which aims to make the code a bit more
> readable.
> It has been tested on: OMAP4 PandaBoard, OMAP4 Blaze, OMAP3 BeagleBoard, OMAP3
> Zoom2.

I will resend the series since I need to add two more patches to avoid build
breakage in zoom2.

> 
> Regards,
> Peter
> ---
> Peter Ujfalusi (10):
>   mfd: twl-core: Clean up module id lookup and definitions
>   mfd: twl-core: No need to check for invalid subchip ID
>   mfd: twl-core: Use the lookup table to find the correct subchip for
>     the modules
>   mfd: twl-core: Allocate twl_modules dynamically
>   mfd: twl-core: Do not try to call legacy mfd add_children() when
>     booted with DT
>   mfd: twl-core: Do not create dummy pdata when booted with DT
>   mfd: twl-core: Move 'inuse' check early at probe time
>   mfd: twl-core: Collect global variables behind one private structure
>     (global)
>   mfd: twl-core: Remove no longer valid comment regarding to write
>     buffer size
>   mfd: twl-core: Move twl_i2c_read/write_u8 to header as inline function
>  drivers/mfd/twl-core.c  | 362 +++++++++++++++++++++---------------------------
>  include/linux/i2c/twl.h |  84 +++++------
>  2 files changed, 205 insertions(+), 241 deletions(-)
> 


-- 
Péter
