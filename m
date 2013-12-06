Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab3LFSZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:25:07 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56847 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534Ab3LFSZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:25:05 -0500
Date: Fri, 6 Dec 2013 12:25:02 -0600
From: rkuo <rkuo@codeaurora.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] arch: hexagon: kernel: hexagon_ksyms.c: export
 related symbols which various modules need
Message-ID: <20131206182502.GF11490@codeaurora.org>
References: <529811AE.8050502@gmail.com>
 <20131203011222.GA23175@codeaurora.org>
 <529DCE06.3040508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529DCE06.3040508@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 08:26:46PM +0800, Chen Gang wrote:
> Need export all related functions and symbols for various modules with
> allmodconfig. The related errors:
> 
>     MODPOST 2879 modules
>   ERROR: "__vmyield" [sound/sound_firmware.ko] undefined!
>   ERROR: "__phys_offset" [sound/drivers/snd-dummy.ko] undefined!
>   ERROR: "ioremap_nocache" [drivers/char/ipmi/ipmi_si.ko] undefined!
>   ERROR: "__iounmap" [drivers/char/ipmi/ipmi_si.ko] undefined!
>   ...
> 
> For including files, need "linux/*" first, then "asm/*". All related
> included files and symbols need be sorted by alphabetical order.
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/hexagon/kernel/hexagon_ksyms.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 

OK, hopefully I didn't leave anything out, but I'll try to upstream the
patches with my tree hopefully in the next window.  Thanks!

Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
