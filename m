Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbaKTIGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:06:33 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:32871 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaKTIGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:06:32 -0500
Date: Thu, 20 Nov 2014 00:06:27 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v4 1/4] mtd: nand: provide detailed description for raw
 read/write page methods
Message-ID: <20141120080627.GB3212@norris-Latitude-E6410>
References: <1413794777-32220-1-git-send-email-boris.brezillon@free-electrons.com>
 <1413794777-32220-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413794777-32220-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:46:14AM +0200, Boris Brezillon wrote:
> read_page_raw and write_page_raw method description is not clear enough.
> It clearly specifies that ECC correction should not be involved but does
> not talk about specific layout (by layout I mean where in-band and
> out-of-band data are stored on the NAND media) used by NAND/ECC
> controllers.
> 
> Those specific layouts might impact MTD users and thus should be hidden (as
> already done in the standard NAND_ECC_HW_SYNDROME implementation).
> 
> Clearly state this constraint in the nand_ecc_ctrl struct documentation.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Pushed this patch to l2-mtd.git. Thanks!

Brian
