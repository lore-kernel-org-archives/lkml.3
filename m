Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3FAJAE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:00:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54688 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3FAI75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 04:59:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Kumar Gala <galak@kernel.crashing.org>,
        U Bhaskar-B22300 <B22300@freescale.com>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] can: flexcan: remove HAVE_CAN_FLEXCAN Kconfig symbol
Date: Sat, 01 Jun 2013 10:59:03 +0200
Message-ID: <4297748.x0TtCUl2dJ@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1368781157-4646-1-git-send-email-mkl@pengutronix.de>
References: <1368781157-4646-1-git-send-email-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0G9AAJ3osV3srPPxXloNF0yluCR3jpPbR522IgVKYrW
 /NaDqdyrf44S9UtdEwPpIMWxkDpclhzO4ftUDxjvyhpdhW0M3v
 Y5exzMCrJ18nZ/nUKcCDLKNSu4ZnGoWiREGoM+8P1cHN0Y5f7P
 QV2oLIcxZOtwjRSc+6wA1qQ8zsKPaUULPcNWFbyYJWXmj4zjIv
 h0vZAT7R9SxDGjLucZTJwpDYUwwu9R9M+iRU6bP29XXQSyNMDj
 2EoyvpF6gP7GKI9HfwSqF7weEdatdAKhZrmWeo+fg2Xjwo2vGa
 BtMiVQ31aULEiUl5C/IuSHXVyDBL8YBHSkf1EphNE/1m1xS9Eo
 XRF3Xw+KShyiqpSZ7ZY8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 May 2013 10:59:17 Marc Kleine-Budde wrote:
> This patch removes the Kconfig symbol HAVE_CAN_FLEXCAN from arch/{arm,powerpc}
> and allowing compilation unconditionally on all arm and powerpc platforms.
> 
> This brings a bigger compile time coverage and removes the following dependency
> warning found by Arnd Bergmann:
> 
>     warning: (SOC_IMX28 && SOC_IMX25 && SOC_IMX35 && IMX_HAVE_PLATFORM_FLEXCAN &&
>         SOC_IMX53 && SOC_IMX6Q) selects HAVE_CAN_FLEXCAN
>     which has unmet direct dependencies (NET && CAN && CAN_DEV)
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: U Bhaskar-B22300 <B22300@freescale.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks for addressing this!
