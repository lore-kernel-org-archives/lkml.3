Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaKEVGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:06:54 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64907 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaKEVGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:06:51 -0500
Date: Wed, 5 Nov 2014 13:06:47 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Marek Vasut <marex@denx.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        Harini Katakam <harini.katakam@xilinx.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: spi-nor: Add support for SST spi flash
Message-ID: <20141105210647.GU23619@ld-irv-0074>
References: <29606567142da0d52c462ef0aebacc2b91fe2508.1413891469.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29606567142da0d52c462ef0aebacc2b91fe2508.1413891469.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 01:37:59PM +0200, Michal Simek wrote:
> From: Harini Katakam <harini.katakam@xilinx.com>
> 
> Add sst25wf080 to the spi-nor device id table.
> 
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> Reviewed-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Applied to l2-mtd.git. Thanks!

Brian
