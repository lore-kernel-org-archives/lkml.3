Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161857Ab3DEONb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 10:13:31 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:34803 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161806Ab3DEONa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:13:30 -0400
X-Auth-Info: l0pqlijVc7KUm5QhQ4uai1o/Mby+0eKtrE+85nO7thM=
From: Marek Vasut <marex@denx.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: imx23-olinuxino: Set the sdcard as non-removable
Date: Fri, 5 Apr 2013 16:11:14 +0200
User-Agent: KMail/1.13.7 (Linux/3.8-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        fabio.estevam@freescale.com, linux@arm.linux.org.uk,
        otavio@ossystems.com.br, f.koliqi@gmail.com,
        linux-kernel@vger.kernel.org, maxime.ripard@free-electrons.com
References: <1365135413-31493-1-git-send-email-aletes.xgr@gmail.com> <20130405091656.GD2667@S2101-09.ap.freescale.net>
In-Reply-To: <20130405091656.GD2667@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304051611.15003.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Shawn Guo,

> On Fri, Apr 05, 2013 at 01:16:53AM -0300, Alexandre Pereira da Silva wrote:
> > The imx23-olinuxino sdcard doesn't support card detect.
> 
> So it sounds more like a "broken-cd" rather than "non-removable"?

The CD line is working perfectly well on this board, so I don't get it.

Best regards,
Marek Vasut
