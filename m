Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbbABO5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 09:57:42 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40296 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbABO5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 09:57:41 -0500
Date: Fri, 2 Jan 2015 20:27:29 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: WARNING: at drivers/gpu/drm/i915/intel_display.c:11375 [i915] in
 3.19-rc2
Message-ID: <20150102145728.GA2643@sudip-PC>
References: <20150101142215.GA2570@yulia-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150101142215.GA2570@yulia-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2015 at 05:22:15PM +0300, Andrey Skvortsov wrote:
> Hi,
> 
> this warning does not exist in 3.19-rc1, but it happens every boot in
> 3.19-rc2. If you need any other information or data, I would be glad
> to help to debug it. 

mine is also i915, but i am not seeing any warning. if you send me your .config, then i can try booting using that.
the current kernel version is : 3.19.0-rc2-next-20141231+

thanks
sudip

> 
> [   12.848428] ------------[ cut here ]------------
> [   12.848479] WARNING: CPU: 1 PID: 328 at drivers/gpu/drm/i915/intel_display.c:11375 intel_crtc_set_config+0x3de/0xb36 [i915]()
> [   12.848649] ---[ end trace da6972fb56a05968 ]---
> 
> -- 
> Best regards,
> Andrey Skvortsov
> 
> Secure e-mail with gnupg: See http://www.gnupg.org/
> PGP Key ID: 0x57A3AEAD
> 
> 
