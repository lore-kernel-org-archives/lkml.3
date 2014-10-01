Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaJAOfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:35:05 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:44722 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaJAOfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:35:03 -0400
X-Auth-Info: d4fODyQq3ZzEd1dIawboh3SlBFGsuu2CM0tqlOoAr+g=
From: Marek Vasut <marex@denx.de>
To: bpqw <bpqw@micron.com>
Subject: Re: [PATCH 1/1 v3] driver:mtd:spi-nor: Add Micron quad I/O support
Date: Wed, 1 Oct 2014 16:33:18 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com> <201409261046.07132.marex@denx.de> <A765B125120D1346A63912DDE6D8B6315E3D45@NTXXIAMBX02.xacn.micron.com>
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315E3D45@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201410011633.18150.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 01, 2014 at 04:28:17 PM, bpqw wrote:
> This patch adds code which enables Quad I/O mode on Micron SPI NOR flashes.
> 
> For Micron SPI NOR flash, enabling or disabling quad I/O protocol is
> controlled by EVCR (Enhanced Volatile Configuration Register), Quad I/O
> protocol bit 7. When EVCR bit 7 is reset to 0, the SPI NOR flash will
> operate in quad I/O mode.
> 
> Signed-off-by: bean huo <beanhuo@micron.com>

I don't see anything obviously wrong.

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
