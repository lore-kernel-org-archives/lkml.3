Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbbATSfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:35:20 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:63609 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbbATSfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:35:16 -0500
Date: Tue, 20 Jan 2015 19:35:09 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
To: mturquette@linaro.org
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        festevam@gmail.com, harald@ccbib.org,
        linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>
Message-ID: <1913991589.463352.1421778909585.JavaMail.open-xchange@oxbaltgw06.schlund.de>
In-Reply-To: <201412281930.17676.marex@denx.de>
References: <1419762402-4548-1-git-send-email-stefan.wahren@i2se.com> <201412281930.17676.marex@denx.de>
Subject: Re: [PATCH V2] clk: mxs: Fix invalid 32-bit access to frac
 registers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.6.0-Rev36
X-Originating-Client: com.openexchange.ox.gui.dhtml
X-Provags-ID: V03:K0:ZWF82+UokFxvTIBQR1sb61eNLkHHAp7wYFqB/mk6k8w25jQc32J
 zloPASw4rGvS/JDsunmMFszlZf8RPDq8aR8DKxOnM1FCTtUdXe8+SJYWsCfB7kpA9KeMvEp
 lWkvuKI2qYeD0MdaEI5xqP/X8TtRT1JEOuDwo+PMcyhgNW21H4f9ovOzklLlLIIH/ttdZGq
 4DOmWl1RrAaGkDpCo/btQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Marek Vasut <marex@denx.de> hat am 28. Dezember 2014 um 19:30 geschrieben:
>
>
> On Sunday, December 28, 2014 at 11:26:42 AM, Stefan Wahren wrote:
> > According to i.MX23 and i.MX28 reference manual the fractional
> > clock control registers must be addressed by byte instructions.
> >
> > This patch fixes the erroneous 32-bit access to these registers
> > and extends the comment in the init functions.
> >
> > Btw the imx23 init now uses a R-M-W sequence just like imx28 init
> > to avoid any clock glitches.
> >
> > The changes has been tested only with a i.MX28 board, because i don't
> > have access to an i.MX23 board.

since i've also a i.MX23 board, i tested this patch successful.

Any conserns about it?

> >
> > Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
>
> I don't see a problem,
>
> Reviewed-by: Marek Vasut <marex@denx.de>
>
> Best regards,
> Marek Vasut
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
