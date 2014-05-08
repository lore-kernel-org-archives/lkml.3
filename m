Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaEHQm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:42:57 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43056 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaEHQm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:42:56 -0400
Date: Thu, 8 May 2014 09:42:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: iop_wdt only builds for mach-iop13xx
Message-ID: <20140508164247.GB22224@roeck-us.net>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-8-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399560990-1402858-8-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 04:56:19PM +0200, Arnd Bergmann wrote:
> All three iop variants we support in Linux (iop32x, iop33x and
> iop13xx) seem to have support for the watchdog hardware, but this
> driver fails to build for the first two of these because it
> uses the IOP13XX_WDTCR_IB_RESET macro that is only defined for
> iop13xx.
> 
> This clarifies the dependency in Kconfig to avoid randconfig
> build errors. It is unlikely that anyone will ever miss support
> for this driver on the ancient iop3xx platforms, so we don't
> need to bother trying to fix it properly.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: linux-watchdog@vger.kernel.org

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
