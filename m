Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3DVOgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:36:06 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:54210 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab3DVOgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:36:03 -0400
X-Auth-Info: Ret7S6r9kSAZM1ca5XZpMH0CoHQl+bR1MZhAG7MU9no=
From: Marek Vasut <marex@denx.de>
To: Hector Palacios <hector.palacios@digi.com>
Subject: Re: How usable is spi-mxs driver?
Date: Mon, 22 Apr 2013 16:35:58 +0200
User-Agent: KMail/1.13.7 (Linux/3.8-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
References: <517511C0.1020006@digi.com>
In-Reply-To: <517511C0.1020006@digi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304221635.58892.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hector Palacios,

> Hello,
> 
> I had the feeling that the MXS SPI driver was rather useless due to the SPI
> being only half-duplex on i.MX28, but it looks like people's using it so I
> was wondering what kind of SPI devices can be driven with it, or if there
> is any trick that allows bi-directional communication.

It can't do full duplex. I tested it with master-slave communication (half-
duplex) and various SPI flashes.

Best regards,
Marek Vasut
