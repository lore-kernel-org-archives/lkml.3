Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239Ab3LIBeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 20:34:36 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:59388 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760210Ab3LIBed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 20:34:33 -0500
Date: Mon, 9 Dec 2013 01:34:32 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: bcousson@baylibre.com, tony@atomide.com, tomi.valkeinen@ti.com,
        balbi@ti.com, sr@denx.de, David.Laight@ACULAB.COM,
        michael@amarulasolutions.com, bigeasy@linutronix.de,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: OMAP3: hwmod data: Don't prevent RESET of USB
 Host module
In-Reply-To: <1386080748-17005-4-git-send-email-rogerq@ti.com>
Message-ID: <alpine.DEB.2.02.1312090134220.32309@utopia.booyaka.com>
References: <1386080748-17005-1-git-send-email-rogerq@ti.com> <1386080748-17005-4-git-send-email-rogerq@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Roger Quadros wrote:

> Unlike what the comment states, errata i660 does not state that we
> can't RESET the USB host module. Instead it states that RESET is the
> only way to recover from a deadlock situation.
> 
> RESET ensures that the module is in a known good state irrespective
> of what bootloader does with the module, so it must be done at boot.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Thanks, queued for v3.13-rc.

- Paul
