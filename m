Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3KHBnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 20:43:42 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:46333 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab3KHBnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 20:43:39 -0500
X-Auth-Info: ug53rtPAS67Cxz2uEb/61izCW06h8oVgfXxPhGJqD6A=
From: Marek Vasut <marex@denx.de>
To: Dmitry Artamonow <mad_soft@inbox.lv>
Subject: Re: [PATCH] ARM: pxa/colibri: fix build with CONFIG_USB_OHCI_HCD=y
Date: Fri, 8 Nov 2013 02:43:33 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
References: <1383835013-22215-1-git-send-email-mad_soft@inbox.lv>
In-Reply-To: <1383835013-22215-1-git-send-email-mad_soft@inbox.lv>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201311080243.33269.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dmitry Artamonow,

> Fix following build failure observed when support for
> OHCI host controller is enabled.
> 
>   CC      arch/arm/mach-pxa/colibri-evalboard.o
> arch/arm/mach-pxa/colibri-evalboard.c: In function 'colibri_ohci_init':
> arch/arm/mach-pxa/colibri-evalboard.c:68: error: implicit declaration of
> function 'IOMEM' make[1]: *** [arch/arm/mach-pxa/colibri-evalboard.o]
> Error 1
> make: *** [arch/arm/mach-pxa] Error 2
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.lv>

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
