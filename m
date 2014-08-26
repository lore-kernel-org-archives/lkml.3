Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbaHZH6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:58:45 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60664 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752889AbaHZH6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:58:44 -0400
Date: Tue, 26 Aug 2014 08:58:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: kpark3469@gmail.com
Cc: keun-o.park@windriver.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, afzal.mohd.ma@gmail.com
Subject: Re: [PATCHv2] ARM: debug: uncompress debug support for omap2plus
Message-ID: <20140826075831.GU30401@n2100.arm.linux.org.uk>
References: <1409038140-7433-1-git-send-email-kpark3469@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409038140-7433-1-git-send-email-kpark3469@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 04:28:59PM +0900, kpark3469@gmail.com wrote:
> From: Sahara <keun-o.park@windriver.com>
> 
> Since OMAP low-level debug code places data in the .data section,
> The symbol DEBUG_UNCOMPRESS was defined with !DEBUG_OMAP2PLUS_UART.
> This patch removes the part using data section in debug/omap2plus.S,
> so DEBUG_UNCOMPRESS is now available on OMAP system.
> 
> Signed-off-by: Sahara <keun-o.park@windriver.com>
> Tested-by: Afzal Mohammed <afzal.mohd.ma@gmail.com> (on am335x beagle
> bone white)

You need to consider whom you are sending this to.  It would be well
worth including the OMAP maintainer, Tony Lindgren.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
