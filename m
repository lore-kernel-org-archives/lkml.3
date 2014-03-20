Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbaCTSzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:55:00 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:63952 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaCTSy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:54:57 -0400
Date: Thu, 20 Mar 2014 11:54:52 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Warner Losh <imp@bsdimp.com>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        David Woodhouse <dwmw2@infradead.org>, galak@codeaurora.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        grygorii.strashko@ti.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH 2/3] mtd: davinci-nand: add dts property for
 NAND_NO_SUBPAGE_WRITE option
Message-ID: <20140320185452.GB21018@ld-irv-0074>
References: <1395335184-4745-1-git-send-email-ivan.khoronzhuk@ti.com>
 <1395335184-4745-3-git-send-email-ivan.khoronzhuk@ti.com>
 <532B2183.2080309@ti.com>
 <20140320172912.GW31517@norris-Latitude-E6410>
 <532B2766.6090506@ti.com>
 <D69011BE-C37F-4085-B992-45F6F32AF1D0@gmail.com>
 <532B2D3F.6050004@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532B2D3F.6050004@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 02:02:39PM -0400, Santosh Shilimkar wrote:
> On Thursday 20 March 2014 01:44 PM, Warner Losh wrote:
> > I though sub page writing was one of the fields in the onfi and/or jedec(toggle) meta data structures. Have you looked there?
> > 
> Am not sure if I follow you. The limitation is from the TI NAND controller(AEMIF) and
> not the NAND memory. 

That doesn't match the patch description, which says "that flash doesn't
support subpage writing". Flash != flash controller.

Which one is it? If it's a controller limitation, I think we should be
able to pull this from a "compatible" property, no?

Brian
