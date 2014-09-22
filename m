Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaIVSNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:13:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50882 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753486AbaIVSNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:13:18 -0400
Date: Mon, 22 Sep 2014 20:13:15 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Yassin Jaffer <yassinjaffer@gmail.com>
Subject: Re: [PATCH v2 1/2] mtd: nand: support ONFI timing mode retrieval
 for non-ONFI NANDs
Message-ID: <20140922201315.022fefea@bbrezillon>
In-Reply-To: <20140922175834.GM1193@ld-irv-0074>
References: <1411395911-30365-1-git-send-email-boris.brezillon@free-electrons.com>
	<1411395911-30365-2-git-send-email-boris.brezillon@free-electrons.com>
	<20140922175834.GM1193@ld-irv-0074>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 10:58:34 -0700
Brian Norris <computersforpeace@gmail.com> wrote:

> On Mon, Sep 22, 2014 at 04:25:10PM +0200, Boris BREZILLON wrote:
> > Add an onfi_timing_mode_default field to nand_chip and nand_flash_dev in
> > order to support NAND timings definition for non-ONFI NAND.
> > 
> > NAND that support better timings mode than the default one have to define
> > a new entry in the nand_ids table.
> > 
> > The default timing mode should be deduced from timings description from
> > the datasheet and the ONFI specification
> > (www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf, chapter 4.15
> > "Timing Parameters").
> > You should choose the closest mode that fit the timings requirements of
> > your NAND chip.
> > 
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> 
> You have some (new?) checkpatch warnings:
> 

Sorry for that. I just sent a new version fixing those warnings.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
