Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161908Ab3DEOxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 10:53:48 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:32850 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161785Ab3DEOxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:53:48 -0400
MIME-Version: 1.0
In-Reply-To: <201304051611.15003.marex@denx.de>
References: <1365135413-31493-1-git-send-email-aletes.xgr@gmail.com>
	<20130405091656.GD2667@S2101-09.ap.freescale.net>
	<201304051611.15003.marex@denx.de>
Date: Fri, 5 Apr 2013 11:53:47 -0300
Message-ID: <CAAAP30FMObPdRg60eNov3FKRvycVrBxV-9DCu05Pb4Fx__H8Qw@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: imx23-olinuxino: Set the sdcard as non-removable
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Marek Vasut <marex@denx.de>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@linaro.org>, fabio.estevam@freescale.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Otavio Salvador <otavio@ossystems.com.br>, f.koliqi@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, maxime.ripard@free-electrons.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 11:11 AM, Marek Vasut <marex@denx.de> wrote:
> The CD line is working perfectly well on this board, so I don't get it.

In the schematics of this board, the SSP1_DETECT pin is connected to
the green led. As I see, there is no way, the hardware can detect card
removal. Am I missing something here?
