Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab3DCEhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 00:37:37 -0400
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:59025 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759516Ab3DCEhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 00:37:36 -0400
Date: Wed, 3 Apr 2013 06:33:30 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCHv3 0/6] fb: vt8500: patches for 3.10
Message-ID: <20130403043330.GM20693@game.jcrosoft.org>
References: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12831881240139770804
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrkeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrkeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07:20 Wed 03 Apr     , Tony Prisk wrote:
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
on the whole serie

Best Regards,
J.
> V3 Changes:
> Tidied up patch 1 as requested by Jean-Christophe - Makes the patch much
> simpler.
> 
> V2 Changes:
> Split the SoC and board portions of the binding into their respective files.
> Removed the forced non-interlaced code from wm8505fb.c and vt8500lcdfb.c
> 
> Julia Lawall (1):
>   drivers/video/wm8505fb.c: use devm_ functions
> 
> Tony Prisk (5):
>   video: vt8500: Make wmt_ge_rops optional
>   video: vt8500: Remove unused platform_data/video-vt8500lcdfb.h
>   video: vt8500: Correct descriptions in video/Kconfig
>   video: vt8500: Adjust contrast in wm8505 framebuffer driver.
>   video: fb: vt8500: Convert framebuffer drivers to standardized
>     binding
> 
>  .../devicetree/bindings/video/via,vt8500-fb.txt    |   48 ++-----
>  .../devicetree/bindings/video/wm,wm8505-fb.txt     |   32 +++--
>  arch/arm/boot/dts/vt8500-bv07.dts                  |   34 ++---
>  arch/arm/boot/dts/vt8500.dtsi                      |    4 +-
>  arch/arm/boot/dts/wm8505-ref.dts                   |   34 ++---
>  arch/arm/boot/dts/wm8505.dtsi                      |    4 +-
>  arch/arm/boot/dts/wm8650-mid.dts                   |   36 +++--
>  arch/arm/boot/dts/wm8650.dtsi                      |    4 +-
>  arch/arm/boot/dts/wm8850-w70v2.dts                 |   40 +++---
>  arch/arm/boot/dts/wm8850.dtsi                      |    4 +-
>  drivers/video/Kconfig                              |   37 +++--
>  drivers/video/vt8500lcdfb.c                        |   55 +++-----
>  drivers/video/wm8505fb.c                           |  144 ++++++--------------
>  drivers/video/wmt_ge_rops.h                        |   23 ++++
>  include/linux/platform_data/video-vt8500lcdfb.h    |   31 -----
>  15 files changed, 211 insertions(+), 319 deletions(-)
>  delete mode 100644 include/linux/platform_data/video-vt8500lcdfb.h
> 
> -- 
> 1.7.9.5
> 
