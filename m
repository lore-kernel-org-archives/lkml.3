Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab3BOLyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 06:54:46 -0500
Received: from sauhun.de ([89.238.76.85]:33366 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab3BOLyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 06:54:44 -0500
Date: Fri, 15 Feb 2013 12:54:38 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-i2c@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 10/11] ARM: s3c: i2c: add platform_device forward
 declaration
Message-ID: <20130215115438.GA21335@the-dreams.de>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
 <1360849767-1463135-11-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360849767-1463135-11-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 02:49:26PM +0100, Arnd Bergmann wrote:
> A recent cleanup to the mach-osiris.c file is causing build errors
> because the i2c-s3c2410.h header file is included before we see
> the definition for platform_device. The fix is to make the header file
> more robust against inclusion from other places. While this should
> normally go through the i2c tree, the bug only exists in arm-soc
> at the moment, so it's easier to fix it there before it goes upstream.
> 
> Without this patch, building s3c2410_defconfig results in:
> 
> arch/arm/mach-s3c24xx/mach-osiris.c:34:0:
> include/linux/platform_data/i2c-s3c2410.h:37:26: warning: 'struct platform_device' declared inside parameter list [enabled by default]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Fine with me:

Acked-by: Wolfram Sang <wsa@the-dreams.de>
