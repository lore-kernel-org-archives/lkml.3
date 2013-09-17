Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab3IQCYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 22:24:25 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:53861 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab3IQCYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 22:24:21 -0400
Date: Mon, 16 Sep 2013 19:24:17 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: onenand: omap: remove two unused functions
Message-ID: <20130917022417.GN4550@ld-irv-0074.broadcom.com>
References: <1375899409.7303.61.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375899409.7303.61.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 08:16:49PM +0200, Paul Bolle wrote:
> Nothing calls omap2_onenand_rephase(). And __adjust_timing() is only
> called by omap2_onenand_rephase(). Remove these two unused functions.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Completely untested.

Compile-tested successfully here. And it gets rid of a few sparse warnings:

  drivers/mtd/onenand/omap2.c:592:5: warning: no previous prototype for 'omap2_onenand_rephase' [-Wmissing-prototypes]
  drivers/mtd/onenand/omap2.c:592:5: warning: symbol 'omap2_onenand_rephase' was not declared. Should it be static? [sparse]

Applied to l2-mtd.git. Thanks!

Brian
