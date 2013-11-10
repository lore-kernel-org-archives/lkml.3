Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163Ab3KJGCG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 01:02:06 -0500
Received: from smtp-66.nebula.fi ([83.145.220.66]:47013 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750866Ab3KJGCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 01:02:03 -0500
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Nov 2013 01:02:03 EST
Date: Sun, 10 Nov 2013 07:51:46 +0200
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonas Bonn <jonas@southpole.se>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Mehall <contact@kevinmehall.net>,
        linux@openrisc.net
Subject: Re: [ORLinux] [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
Message-ID: <20131110055145.GA7947@chokladfabriken.org>
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 09:37:31PM +0100, Geert Uytterhoeven wrote:
> Add a DTS and defconfig for the Terasic DE0-Nano Development and Education
> Board running ORPSoC.  This board contains an Altera Cyclone IV FPGA with
> support chips and I/O.
> 
> The DTS was derived from published versions by Kevin Mehall and Marek
> Czerski.

To give credit where credit is due, this was created by:
Gong Tao <gongtao0607@gmail.com>

> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Kevin Mehall <contact@kevinmehall.net>
> Cc: Marek Czerski <ma.czerski@gmail.com>
> ---
> Notable changes:
>   - Change flash0 to spansion,s25sl064p, due to kernel message
>     m25p80 spi32766.0: found s25sl064p, expected m25p10

This is due to Altera changing the EPCS chip on newer revisions
of that board, older versions are "relabeled" m25p10 and
newer once s25sl064p.
The change is fine though, you have to pick one.

Stefan
