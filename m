Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbaJUWZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:25:15 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35128 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaJUWZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:25:13 -0400
X-Auth-Info: nHgjfcgxMmPazTOPPwsaH7j1M/WFfQqQaBPkvmNkP5g=
From: Marek Vasut <marex@denx.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH] mtd: spi-nor: Add support for SST spi flash
Date: Wed, 22 Oct 2014 00:08:51 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Michal Simek <michal.simek@xilinx.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        monstr@monstr.eu, Harini Katakam <harini.katakam@xilinx.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <b32955@freescale.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
References: <29606567142da0d52c462ef0aebacc2b91fe2508.1413891469.git.michal.simek@xilinx.com> <CACna6rzp1anqhLc-CfYmD4QA4ghYMWWjXmO9DnHHo824QobaMQ@mail.gmail.com>
In-Reply-To: <CACna6rzp1anqhLc-CfYmD4QA4ghYMWWjXmO9DnHHo824QobaMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201410220008.51848.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 21, 2014 at 06:43:50 PM, Rafał Miłecki wrote:
> On 21 October 2014 13:37, Michal Simek <michal.simek@xilinx.com> wrote:
> > From: Harini Katakam <harini.katakam@xilinx.com>
> > 
> > Add sst25wf080 to the spi-nor device id table.
> 
> I guess commit message could include some details. We already support
> plenty of SST flashes without this patch, don't we?

This change is so trivial that saying "we're adding this new flash chip ID to 
the ID table", which is what Michal did, is completely sufficient in my opinion.

Best regards,
Marek Vasut
