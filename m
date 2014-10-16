Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaJPKTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:19:12 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:57620 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaJPKTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:19:10 -0400
MIME-Version: 1.0
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315E6FE5@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315E62CB@NTXXIAMBX02.xacn.micron.com>
	<CACna6rw4g1wWPv+VgL8WeA9rz-j8A6k+4bN7D=MQ9OU-BinToA@mail.gmail.com>
	<A765B125120D1346A63912DDE6D8B6315E6F6F@NTXXIAMBX02.xacn.micron.com>
	<CACna6rxNbPzSYbe9GjQCSAeB8FgVi6ZpgKo=AB=6nYc4QcqN1g@mail.gmail.com>
	<A765B125120D1346A63912DDE6D8B6315E6FE5@NTXXIAMBX02.xacn.micron.com>
Date: Thu, 16 Oct 2014 12:19:09 +0200
Message-ID: <CACna6ryjvp1F7=u0NSK77G5X8dQgutuQRwg3AX_XCRS=MG_Vcg@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: bpqw <bpqw@micron.com>
Cc: Brian Norris <computersforpeace@gmail.com>, Marek Vasut <marex@denx.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 October 2014 10:41, bpqw <bpqw@micron.com> wrote:
> By the way ,I still don't understand why you specify id NULL in you patch:

I guess I needed it for my Broadcom SPI driver, see:
mtd: bcm53xxspiflash: new driver for SPI flahes on Broadcom ARM SoCs
https://patchwork.ozlabs.org/patch/381902/

But I'll need to re-think that and update my patch.
