Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaJ2JRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:17:06 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40032 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbaJ2JRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:17:00 -0400
Message-ID: <1414574218.15269.4.camel@lp-lvrv.comap.cz>
Subject: Re: [PATCH v3 2/2] mtd: nand: omap: Synchronize the access to the
 ECC engine
From: Rostislav Lisovy <lisovy@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz,
        sojkam1@fel.cvut.cz, Rostislav Lisovy <lisovy@merica.cz>
Date: Wed, 29 Oct 2014 10:16:58 +0100
In-Reply-To: <1412259404-5202-1-git-send-email-lisovy@merica.cz>
References: <542D46A1.9090905@ti.com>
	 <1412259404-5202-1-git-send-email-lisovy@merica.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 16:16 +0200, Rostislav Lisovy wrote:
> The AM335x Technical Reference Manual (spruh73j.pdf) says
> "Because the ECC engine includes only one accumulation context,
> it can be allocated to only one chip-select at a time ... "
> (7.1.3.3.12.3). Since the commit 97a288ba2cfa ("ARM: omap2+:
> gpmc-nand: Use dynamic platform_device_alloc()") gpmc-nand
> driver supports multiple NAND flash devices connected to
> the single controller.
> Use global 'struct nand_hw_control' among multiple NAND
> instances to synchronize the access to the single ECC Engine.
> 
> Tested with custom AM335x board using 2x NAND flash chips.
> 
> Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>


Just a kind appeal if someone is willing to review this.

Best regards;
Rostislav

