Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab3DBSsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:48:40 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37742 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890Ab3DBSsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:48:38 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:c028]
In-Reply-To: <1364297952-32473-1-git-send-email-nicolas.ferre@atmel.com>
References: <1364201369-12047-1-git-send-email-nicolas.ferre@atmel.com>
	<1364297952-32473-1-git-send-email-nicolas.ferre@atmel.com>
Date: Tue, 2 Apr 2013 11:48:36 -0700
Message-ID: <CAOesGMj+etPUMWffx2CiDtbWbB9A5_6QPbkTsmbEqCiBnkhm3A@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: at91: add Acme Systems Aria G25 board
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        tanzilli@acmesystems.it, dgilbert@interlog.com,
        Robert.Nelson@digikey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just saw this since it came in through a pull request

On Tue, Mar 26, 2013 at 4:39 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> From: Douglas Gilbert <dgilbert@interlog.com>
>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/boot/dts/ariag25.dts | 175 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 175 insertions(+)
>  create mode 100644 arch/arm/boot/dts/ariag25.dts
>
> diff --git a/arch/arm/boot/dts/ariag25.dts b/arch/arm/boot/dts/ariag25.dts
> new file mode 100644
> index 0000000..b43266f
> --- /dev/null
> +++ b/arch/arm/boot/dts/ariag25.dts

Please prefix the boards with the platform. Most other SoCs already do
this, and I see now that some at91 boards haven't been prefixed in the
past, but it's a good idea to not add more of them.

So, at91-ariag25.dts is a good name in this case.


-Olof
