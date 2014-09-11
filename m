Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbaIKQc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:32:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48388 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750860AbaIKQc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:32:28 -0400
Date: Thu, 11 Sep 2014 18:32:25 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 7/7] ARM: at91: add sama5d4 support to sama5_defconfig
Message-ID: <20140911183225.1a9363bd@free-electrons.com>
In-Reply-To: <1410450852-1834-8-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410450852-1834-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1410450852-1834-8-git-send-email-alexandre.belloni@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alexandre Belloni,

On Thu, 11 Sep 2014 17:54:12 +0200, Alexandre Belloni wrote:

> @@ -66,7 +67,6 @@ CONFIG_MTD=y
>  CONFIG_MTD_CMDLINE_PARTS=y
>  CONFIG_MTD_BLOCK=y
>  CONFIG_MTD_CFI=y
> -CONFIG_MTD_M25P80=y
>  CONFIG_MTD_NAND=y
>  CONFIG_MTD_NAND_ATMEL=y
>  CONFIG_MTD_SPI_NOR=y

Most likely this is not intended to be part of this patch.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
