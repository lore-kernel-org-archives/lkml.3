Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbaD3Wd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:33:56 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:43591 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaD3Wdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:33:55 -0400
Date: Wed, 30 Apr 2014 15:33:39 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, dwmw2@infradead.org,
        galak@codeaurora.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, rob@landley.net,
        linux@arm.linux.org.uk, grygorii.strashko@ti.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        m-karicheri2@ti.com, Warner Losh <imp@bsdimp.com>
Subject: Re: [PATCH v2] mtd: davinci-nand: disable subpage write for
 keystone-nand
Message-ID: <20140430223339.GF2497@norris-Latitude-E6410>
References: <1395346112-13350-1-git-send-email-ivan.khoronzhuk@ti.com>
 <532B4C36.8060405@ti.com>
 <5343F0D6.2010804@ti.com>
 <20140416070833.GA5512@norris-Latitude-E6410>
 <534E51BF.9050508@ti.com>
 <535E5AF5.2020203@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535E5AF5.2020203@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 09:43:17AM -0400, Santosh Shilimkar wrote:
> On Wednesday 16 April 2014 05:47 AM, Ivan Khoronzhuk wrote:
> > On 04/16/2014 10:08 AM, Brian Norris wrote:
> >> On Tue, Apr 08, 2014 at 03:51:34PM +0300, Ivan Khoronzhuk wrote:
> >>> Could you pick up subj patch?
> >> Pushed to l2-mtd.git. Is it critical this goes in for 3.15? It's
> >> currently queued for -next (3.16).
> >>
> 
> [..]
> 
> > 
> > This is a critical fix and it should be for 3.15.
> Ping. 3.15-rc3 is already out and I still see this fix merged
> yet.

OK, cherry-picked to linux-mtd.git with the intention of sending to
Linus soon.

Regards,
Brian
