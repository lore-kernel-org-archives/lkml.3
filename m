Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab3L0JLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 04:11:04 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:60717 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754104Ab3L0JLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:11:00 -0500
Message-ID: <1388135456.5072.3.camel@x220>
Subject: Re: [PATCH] mtd: nand: remove pasemi_nand driver
From: Paul Bolle <pebolle@tiscali.nl>
To: Olof Johansson <olof@lixom.net>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Date: Fri, 27 Dec 2013 10:10:56 +0100
In-Reply-To: <1388123524-9000-1-git-send-email-olof@lixom.net>
References: <1388123524-9000-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Dec 2013 09:10:56.0662 (UTC) FILETIME=[8D305360:01CF02E3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-26 at 21:52 -0800, Olof Johansson wrote:
> The PA Semi platform is sparsely used these days (with just a handful
> of known users out there). I'm 100% sure none of them use the MTD NAND
> driver -- most standard use cases include PCI-e SATA controllers for
> storage instead, and boot is done from LPC NOR flash.
> 
> So, there's little reason to keep carrying a driver that's not used by
> anybody and that just gets hit by some tree-wide or tools-based changes
> every now and then.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  drivers/mtd/nand/pasemi_nand.c |  238 ----------------------------------------
>  1 file changed, 238 deletions(-)
>  delete mode 100644 drivers/mtd/nand/pasemi_nand.c

If this gets accepted we should remove the related entry in
drivers/mtd/nand/Kconfig and the related line in
drivers/mtd/nand/Makefile too, shouldn't we?


Paul Bolle

