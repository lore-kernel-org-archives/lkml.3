Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906Ab3BJAri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 19:47:38 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61373 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab3BJArg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 19:47:36 -0500
Date: Sat, 9 Feb 2013 16:47:40 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, FlorianSchandinat@gmx.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, jhovold@gmail.com, jacmet@sunsite.dk
Subject: Re: [PATCH 0/5] at91: atmel_lcdfb: regression fixes and cpu_is
 removal
Message-ID: <20130210004740.GH16278@quad.lixom.net>
References: <cover.1360340791.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1360340791.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 05:35:13PM +0100, Nicolas Ferre wrote:
> These patches fix a regression in 16-bpp support for older SOCs which use
> IBGR:555 rather than BGR:565 pixel layout. Use SOC-type to determine if the
> controller uses the intensity-bit and restore the old layout in that case.
> 
> The last patch is a removal of uses of cpu_is_xxxx() macros in atmel_lcdfb with
> a platform-device-id table and static configurations.
> 
> 
> Patches from Johan Hovold taken from:
> "[PATCH 0/3] atmel_lcdfb: fix 16-bpp regression"
> and
> "[PATCH v2 0/3] ARM: at91/avr32/atmel_lcdfb: remove cpu_is macros"
> patch series to form a clean patch series with my signature.
> 
> Arnd, Olof,
> as it seems that old fbdev drivers are not so much reviewed those days, can we
> take the decision to queue this material through arm-soc with other AT91
> drivers updates?

It would be beneficial to get an ack from Florian. Was he involved in the
review of the code that regressed 16-bpp support in the first place? When was
the regression introduced?


-Olof
