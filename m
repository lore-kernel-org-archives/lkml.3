Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaB1K74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:59:56 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:61130 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaB1K7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:59:55 -0500
Date: Fri, 28 Feb 2014 11:59:25 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Marek Vasut <marex@denx.de>
Cc: Yao Yuan <yao.yuan@freescale.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] i2c: add DMA support for freescale i2c driver
Message-ID: <20140228115925.5fe07693@ipc1.ka-ro>
In-Reply-To: <201402281004.10238.marex@denx.de>
References: <1393481115-22136-1-git-send-email-yao.yuan@freescale.com>
	<201402272139.36076.marex@denx.de>
	<3f58a8abdda74100b4f7b14d0c31c90e@BL2PR03MB338.namprd03.prod.outlook.com>
	<201402281004.10238.marex@denx.de>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Marek Vasut wrote:
> On Friday, February 28, 2014 at 06:19:18 AM, Yao Yuan wrote:
> 
> [...]
> > Yes, here have two dma channels, one for RX and the other one for TX.
> > When we request the channel we should determine it for TX or RX.
> 
> Sorry, I don't quite understand this. If you have two DMA channels, can you not 
> use them both to do full-duplex SPI transfer ?
> 
SPI != I2C


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
