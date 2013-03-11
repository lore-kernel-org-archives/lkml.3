Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab3CKNrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:47:32 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:58058 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122Ab3CKNrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:47:31 -0400
Message-ID: <1363009649.3137.78.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: imx: fix typo "DEBUG_IMX50_IMX53_UART"
From: Paul Bolle <pebolle@tiscali.nl>
To: Fabio Estevam <festevam@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Mon, 11 Mar 2013 14:47:29 +0100
In-Reply-To: <CAOMZO5AhjKV=ja+Agr_pMg4ghB6Vux2ciBnr_M8SQuS4AQ4Bzg@mail.gmail.com>
References: <1363007760.3137.69.camel@x61.thuisdomein>
	 <20130311133720.GB25910@S2101-09.ap.freescale.net>
	 <CAOMZO5AhjKV=ja+Agr_pMg4ghB6Vux2ciBnr_M8SQuS4AQ4Bzg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2013 13:47:29.0659 (UTC) FILETIME=[F92D7CB0:01CE1E5E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 10:41 -0300, Fabio Estevam wrote:
> Please see my commit:
> 
> commit 7356420cd34e40fe27bf26555b0bf3f2849a43dd
> Author: Fabio Estevam <fabio.estevam@freescale.com>
> Date:   Tue Jan 22 10:40:55 2013 -0200
> 
>     ARM: imx: Remove mx508 support
> 
>     Only mx508 based board is mach-mx50_rdp and it has been marked as BROKEN
>     for several releases.
> 
>     mx508 currently lacks clock support.
> 
>     In case someone needs to add mx508 support back, then the
> recommended approach
>     is to use device tree.
> 
>     Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>     Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> 
> ,it does remove the MX50 reference, so this patch is not needed.

That's not correct:
    $ git grep -n DEBUG_IMX50_IMX53_UART v3.9-rc2
    v3.9-rc2:arch/arm/Kconfig.debug:495:                                            DEBUG_IMX50_IMX53_UART || \


Paul Bolle

