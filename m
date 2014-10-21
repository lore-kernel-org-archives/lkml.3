Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbaJUMGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:06:23 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:41519 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaJUMGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:06:22 -0400
X-Auth-Info: wi0oQD+s/+m+psL5t49PhXaWtOfu2j/4E7qZ7cJZav4=
From: Marek Vasut <marex@denx.de>
To: Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] mtd: spi-nor: Add support for SST spi flash
Date: Tue, 21 Oct 2014 13:57:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Harini Katakam <harini.katakam@xilinx.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <b32955@freescale.com>,
        =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-mtd@lists.infradead.org
References: <29606567142da0d52c462ef0aebacc2b91fe2508.1413891469.git.michal.simek@xilinx.com>
In-Reply-To: <29606567142da0d52c462ef0aebacc2b91fe2508.1413891469.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201410211357.20314.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 21, 2014 at 01:37:59 PM, Michal Simek wrote:
> From: Harini Katakam <harini.katakam@xilinx.com>
> 
> Add sst25wf080 to the spi-nor device id table.
> 
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> Reviewed-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
