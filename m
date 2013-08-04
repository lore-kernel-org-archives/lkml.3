Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3HDPtw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 11:49:52 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49585 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab3HDPtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 11:49:45 -0400
Date: Sun, 4 Aug 2013 08:49:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: 3.11-rc3+git: __divdi3 undefined on powerpc (from radeon)
Message-ID: <20130804154943.GA13807@roeck-us.net>
References: <alpine.SOC.1.00.1308031534390.1352@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1308031534390.1352@math.ut.ee>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 03, 2013 at 03:44:26PM +0300, Meelis Roos wrote:
> While trying to compile v3.11-rc3-288-gabe0308 on powerpc 32-bit, 
> it failed with the following linking error:
> 
> ERROR: "__divdi3" [drivers/gpu/drm/radeon/radeon.ko] undefined!
> 
> Some new 64-bit division in radeon that is not implemented on 32-bit 
> powerpc?
> 
> This is new - 3.11-rc3 worked fine.
> 
Not only powerpc - i386 builds fail with the same error.

Guenter
