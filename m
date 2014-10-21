Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbaJUQnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:43:52 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35674 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304AbaJUQnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <29606567142da0d52c462ef0aebacc2b91fe2508.1413891469.git.michal.simek@xilinx.com>
References: <29606567142da0d52c462ef0aebacc2b91fe2508.1413891469.git.michal.simek@xilinx.com>
Date: Tue, 21 Oct 2014 18:43:50 +0200
Message-ID: <CACna6rzp1anqhLc-CfYmD4QA4ghYMWWjXmO9DnHHo824QobaMQ@mail.gmail.com>
Subject: Re: [PATCH] mtd: spi-nor: Add support for SST spi flash
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, monstr@monstr.eu,
        Harini Katakam <harini.katakam@xilinx.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <b32955@freescale.com>, Marek Vasut <marex@denx.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 October 2014 13:37, Michal Simek <michal.simek@xilinx.com> wrote:
> From: Harini Katakam <harini.katakam@xilinx.com>
>
> Add sst25wf080 to the spi-nor device id table.

I guess commit message could include some details. We already support
plenty of SST flashes without this patch, don't we?
