Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaB1MEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:04:05 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:51179 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaB1MEC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:04:02 -0500
X-Auth-Info: Qf3AgbCL9cjxmf8sMDZmixM+STYmlLN/8Lu3usKBUfg=
From: Marek Vasut <marex@denx.de>
To: Lothar =?iso-8859-1?q?Wa=DFmann?= <LW@karo-electronics.de>
Subject: Re: [PATCH 1/3] i2c: add DMA support for freescale i2c driver
Date: Fri, 28 Feb 2014 13:00:30 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: Yao Yuan <yao.yuan@freescale.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1393481115-22136-1-git-send-email-yao.yuan@freescale.com> <201402281004.10238.marex@denx.de> <20140228115925.5fe07693@ipc1.ka-ro>
In-Reply-To: <20140228115925.5fe07693@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201402281300.30907.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 28, 2014 at 11:59:25 AM, Lothar Waßmann wrote:
> Hi,
> 
> Marek Vasut wrote:
> > On Friday, February 28, 2014 at 06:19:18 AM, Yao Yuan wrote:
> > 
> > [...]
> > 
> > > Yes, here have two dma channels, one for RX and the other one for TX.
> > > When we request the channel we should determine it for TX or RX.
> > 
> > Sorry, I don't quite understand this. If you have two DMA channels, can
> > you not use them both to do full-duplex SPI transfer ?
> 
> SPI != I2C

You got me, sorry.

Best regards,
Marek Vasut
