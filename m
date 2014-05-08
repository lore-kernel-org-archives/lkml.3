Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaEHO3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:29:41 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:65073 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaEHO3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:29:39 -0400
Date: Thu, 8 May 2014 15:29:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        dev@linux-sunxi.org, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, linux-mtd@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/9] mtd: nand: define struct nand_timings
Message-ID: <20140508142930.GC5767@lee--X1>
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com>
 <1394647664-8258-2-git-send-email-b.brezillon.dev@gmail.com>
 <20140430175157.GB2497@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140430175157.GB2497@norris-Latitude-E6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Define a struct containing the standard NAND timings as described in NAND
> > datasheets.
> > 
> > Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> > ---
> >  include/linux/mtd/nand.h |   49 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 49 insertions(+)
> > 
> > diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> > index 389b3c5..f3ff3a3 100644
> > --- a/include/linux/mtd/nand.h
> > +++ b/include/linux/mtd/nand.h

[...]

> > + * Parameters)
> 
> Please document the units for these fields here. It looks like you're
> using picoseconds.

Can't we leave this open to interpretation?  For instance, it's more
convenient for our driver to handle these as nano second values.

> > + *
> > + */
> > +
> 
> Extra blank line.
> 
> > +struct nand_sdr_timings {
> > +	u32 tALH_min;
> > +	u32 tADL_min;
> > +	u32 tALS_min;
> > +	u32 tAR_min;
> > +	u32 tCEA_max;
> > +	u32 tCEH_min;
> > +	u32 tCH_min;
> > +	u32 tCHZ_max;
> > +	u32 tCLH_min;
> > +	u32 tCLR_min;
> > +	u32 tCLS_min;
> > +	u32 tCOH_min;
> > +	u32 tCS_min;

	u32 tCSD_min;

> > +	u32 tDH_min;
> > +	u32 tDS_min;
> > +	u32 tFEAT_max;
> > +	u32 tIR_min;
> > +	u32 tITC_max;

	u32 tR_max;

> > +	u32 tRC_min;
> > +	u32 tREA_max;
> > +	u32 tREH_min;
> > +	u32 tRHOH_min;
> > +	u32 tRHW_min;
> > +	u32 tRHZ_max;
> > +	u32 tRLOH_min;
> > +	u32 tRP_min;
> > +	u32 tRR_min;
> > +	u64 tRST_max;
> > +	u32 tWB_max;
> > +	u32 tWC_min;
> > +	u32 tWH_min;
> > +	u32 tWHR_min;
> > +	u32 tWP_min;
> > +	u32 tWW_min;
> > +};
> > +
> >  #endif /* __LINUX_MTD_NAND_H */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
