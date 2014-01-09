Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaAIQjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:39:17 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:39969 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbaAIQjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:39:11 -0500
Date: Thu, 9 Jan 2014 08:33:05 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, linux@arm.linux.org.uk,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        grygorii.strashko@ti.com, pawel.moll@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, galak@kernel.crashing.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH v3] ARM: davinci: aemif: get rid of davinci-nand driver
 dependency on aemif
Message-ID: <20140109163305.GC28655@norris-Latitude-E6410>
References: <1386267092-18615-1-git-send-email-ivan.khoronzhuk@ti.com>
 <52B18C44.2000305@ti.com>
 <52B1915A.7060309@ti.com>
 <52BC1BB8.2070007@ti.com>
 <52CE7C44.1000803@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CE7C44.1000803@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 04:09:00PM +0530, Sekhar Nori wrote:
> On Thursday 26 December 2013 05:36 PM, ivan.khoronzhuk wrote:
> > On 12/18/2013 02:13 PM, Sekhar Nori wrote:
> >> On Wednesday 18 December 2013 05:21 PM, ivan.khoronzhuk wrote:
> >>> Hi, Sekhar
> >>>
> >>> This patch is based on "Reuse davinci-nand driver for Keystone arch"
> >>> series.
> >>> The series has passed review at https://lkml.org/lkml/2013/12/17/241
> >>> and can be found at http://git.infradead.org/l2-mtd.git
> >>>
> >>> This patch can be still applied on top of the series without conflicts.
> >>>
> >>> Can you please pick up the $subject patch if you are OK with it?
> >>
> >> I have no problems with the patch and can pick it too, but need ack from
> >> MTD maintainer (David) as it touches drivers/mtd/ too.
> >>
> >> David,
> >>
> >> If you do not have the patch, we can resend it.
> >>
> >> Thanks,
> >> Sekhar
> >>
> > 
> > Hi Brian,
> > 
> > Do you agree if this patch will go through Davinci tree?
> > 
> > This is the last one we need to reuse Davinci Nand driver for Keystone.
> 
> Since we never got an ack from MTD folks, I am going and go ahead and
> try pushing this through ARM-SoC regardless. I will CC the MTD
> maintainers on the pull request so any objections could even be posted
> there.

Sorry, I've been a little busy / out for vacation. The MTD parts look OK
to me. Feel free to take it in your tree.

Acked-by: Brian Norris <computersforpeace@gmail.com>

Brian
