Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaJVIfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:35:05 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63755 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaJVIfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:35:00 -0400
Date: Wed, 22 Oct 2014 01:34:56 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Tony Lindgren <tony@atomide.com>,
        Roger Quadros <rogerq@ti.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz,
        sojkam1@fel.cvut.cz, Rostislav Lisovy <lisovy@merica.cz>
Subject: Re: [PATCH v2 1/2] mtd: nand: omap: Do not use global variables
Message-ID: <20141022083456.GF16128@brian-ubuntu>
References: <1412252173-20454-1-git-send-email-lisovy@merica.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412252173-20454-1-git-send-email-lisovy@merica.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 02:16:12PM +0200, Rostislav Lisovy wrote:
> Since the commit 97a288ba2cfa ("ARM: omap2+: gpmc-nand: Use
> dynamic platform_device_alloc()") gpmc-nand driver supports
> multiple NAND flash devices connected to the single controller.
> Remove global variable to make the code thread-safe.
> 
> Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
> ---
> Changes since v1:
> * Do not dynamically allocate the 'struct nand_ecclayout' but rather
>   include it in the 'struct omap_nand_info' (Roger Quadros)

Pushed to l2-mtd.git with some small changes to the comment.

Thanks,
Brian
