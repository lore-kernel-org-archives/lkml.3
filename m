Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaDPGVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:21:15 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54175 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbaDPGVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:21:13 -0400
Date: Tue, 15 Apr 2014 23:21:08 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'Christian Engelmayer'" <cengelma@gmx.at>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Artem Bityutskiy'" <artem.bityutskiy@linux.intel.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: nand: omap: =?utf-8?Q?fix?=
 =?utf-8?Q?_compile_warning_on_=E2=80=98erased=5Fsector=5Fbitflips?=
 =?utf-8?B?4oCZ?=
Message-ID: <20140416062108.GM3131@norris-Latitude-E6410>
References: <20140415003205.0bb2cf44@spike>
 <007d01cf5842$435dcba0$ca1962e0$%han@samsung.com>
 <20980858CB6D3A4BAE95CA194937D5E73EAC301C@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EAC301C@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 03:58:56AM +0000, Pekon Gupta wrote:
> >From: Jingoo Han [mailto:jg1.han@samsung.com]
> >>On Tuesday, April 15, 2014 7:32 AM, Christian Engelmayer wrote:
> >>
> >> Commit 2c9f2365 (mtd: nand: omap: ecc.calculate: merge omap3_calculate_ecc_bch4
> >> in omap_calculate_ecc_bch) introduced minor compile warning
> >> "‘erased_sector_bitflips’ defined but not used [-Wunused-function]" when
> >> compiling without CONFIG_MTD_NAND_OMAP_BCH. Move function
> >> erased_sector_bitflips() into the same ifdef section as the only caller.
> >>
> >> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> >
> >Reviewed-by: Jingoo Han <jg1.han@samsung.com>
> >
> Thanks for the patch..
> Acked-by: Pekon Gupta <pekon@ti.com>

Pushed to l2-mtd.git. Thanks!

Brian
