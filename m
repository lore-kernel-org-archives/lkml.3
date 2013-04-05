Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161986Ab3DEQIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:08:20 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:50729 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161931Ab3DEQIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:08:18 -0400
X-Auth-Info: mfR99aumRVIRjy8G8sC7QrTanygtWhfZe+ueFgpe34c=
From: Marek Vasut <marex@denx.de>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH] ARM: dts: imx23-olinuxino: Set the sdcard as non-removable
Date: Fri, 5 Apr 2013 18:08:15 +0200
User-Agent: KMail/1.13.7 (Linux/3.8-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@linaro.org>, fabio.estevam@freescale.com,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Otavio Salvador <otavio@ossystems.com.br>, f.koliqi@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, maxime.ripard@free-electrons.com
References: <1365135413-31493-1-git-send-email-aletes.xgr@gmail.com> <201304051611.15003.marex@denx.de> <CAAAP30FMObPdRg60eNov3FKRvycVrBxV-9DCu05Pb4Fx__H8Qw@mail.gmail.com>
In-Reply-To: <CAAAP30FMObPdRg60eNov3FKRvycVrBxV-9DCu05Pb4Fx__H8Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304051808.16034.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alexandre Pereira da Silva,

> On Fri, Apr 5, 2013 at 11:11 AM, Marek Vasut <marex@denx.de> wrote:
> > The CD line is working perfectly well on this board, so I don't get it.
> 
> In the schematics of this board, the SSP1_DETECT pin is connected to
> the green led. As I see, there is no way, the hardware can detect card
> removal. Am I missing something here?

You're right. Then the design is indeed defective. Sorry.

Best regards,
Marek Vasut
