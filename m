Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3JWUB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 16:01:59 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:32904 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3JWUB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:01:57 -0400
Date: Wed, 23 Oct 2013 13:01:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 23
Message-ID: <20131023200149.GA3519@roeck-us.net>
References: <1382541202-6614-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382541202-6614-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 05:13:22PM +0200, Thierry Reding wrote:
> Hi all,
> 
> I've uploaded today's linux-next tree to the master branch of the
> repository below:
> 
>         git://gitorious.org/thierryreding/linux-next.git
> 
> A next-20131023 tag is also provided for convenience.
> 
> No new conflicts. I've fixed various build failures, so 32-bit and 64-bit
> allmodconfigs build fine on x86. ARM and x86 default configurations also
> build fine. Most of the patches to fix the build failures have been sent
> to the respective maintainers.
> 
Build test results are a bit better than yesterday:
	total: 110 pass: 92 skipped: 4 fail: 14

For the qemu tests, the mips64 build still fails due to an unused variable
'usp' in arch/mips/include/asm/syscall.h, and the sh test crashes with
a NULL pointer access in ata_finalize_port_ops().

Detailed results are, as always, available at http://server.roeck-us.net:8010/builders.

Guenter
