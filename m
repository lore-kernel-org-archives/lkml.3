Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbaGIRWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:22:36 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:37683 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaGIRWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:22:34 -0400
Date: Wed, 9 Jul 2014 10:22:29 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Lee Jones <lee.jones@linaro.org>, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        "Gupta, Pekon\"" <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] mtd: nand: stm_nand_bch: add new driver
Message-ID: <20140709172229.GH7537@ld-irv-0074>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
 <20140703002237.GM3599@ld-irv-0074>
 <20140703100522.756f9715@bbrezillon>
 <20140707235222.GC7537@ld-irv-0074>
 <20140708095855.29c2fb87@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708095855.29c2fb87@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Tue, Jul 08, 2014 at 09:58:55AM +0200, Boris BREZILLON wrote:
> On Mon, 7 Jul 2014 16:52:22 -0700 Brian Norris <computersforpeace@gmail.com> wrote:
> > On Thu, Jul 03, 2014 at 10:05:22AM +0200, Boris BREZILLON wrote:
> > > On Wed, 2 Jul 2014 17:22:37 -0700 Brian Norris <computersforpeace@gmail.com> wrote:
> > > 
> > > AFAIR, the NAND timing representation for non-ONFI chips question was
> > > left unanswered:
> > > 
> > > https://lkml.org/lkml/2014/5/20/581
> > > 
> > > I can definitely respin my NAND timings series, but I'd like to be sure
> > > this is how you want it done before doing so.
> > 
> > Can we start by supporting ONFI-only (or ONFI-only, plus entries in
> > nand_flash_ids[]), and have nand_base provide the translation so drivers
> > can retrieve the info? Then we can begin supporting new drivers like
> > Lee's, and worry about the DT question separately.
> 
> So, basically, I just send a new series with patch 1 and 2 from my sunxi
> NAND series [1] (including the fixes you suggested, of course), right ?
> 
> [1] http://thread.gmane.org/gmane.comp.hardware.netbook.arm.sunxi/7977

Yes, please send 1 and 2 on their own. I think that would be a good
start for supporting these drivers.

Brian
