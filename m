Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaDPHIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:08:43 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61657 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaDPHIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:08:41 -0400
Date: Wed, 16 Apr 2014 00:08:33 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: dwmw2@infradead.org, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        galak@codeaurora.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, rob@landley.net,
        linux@arm.linux.org.uk, grygorii.strashko@ti.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        m-karicheri2@ti.com, Warner Losh <imp@bsdimp.com>
Subject: Re: [PATCH v2] mtd: davinci-nand: disable subpage write for
 keystone-nand
Message-ID: <20140416070833.GA5512@norris-Latitude-E6410>
References: <1395346112-13350-1-git-send-email-ivan.khoronzhuk@ti.com>
 <532B4C36.8060405@ti.com>
 <5343F0D6.2010804@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5343F0D6.2010804@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 03:51:34PM +0300, Ivan Khoronzhuk wrote:
> On 03/20/2014 10:14 PM, Santosh Shilimkar wrote:
> >On Thursday 20 March 2014 04:08 PM, Ivan Khoronzhuk wrote:
> >>From: Murali Karicheri <m-karicheri2@ti.com>
> >>Sub page write doesn't work because of hw issue in controller found on
> >>Keystone SOCs. AEMIF controller is also used on DaVinci SOCs which
> >>don't seems to have any issue. So add "ti,keysone-nand" compatible
> >>to nand driver in order to set NAND_NO_SUBPAGE_WRITE option.
> >>
> >>Cc: Brian Norris <computersforpeace@gmail.com>
> >>Cc: Warner Losh <imp@bsdimp.com>
> >>Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >>
> >>Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> >>Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> >>---
> >>
> >Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> Brian,
> Could you pick up subj patch?

Pushed to l2-mtd.git. Is it critical this goes in for 3.15? It's
currently queued for -next (3.16).

Brian
