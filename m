Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab3HTPky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:40:54 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:60796 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3HTPkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:40:53 -0400
MIME-Version: 1.0
In-Reply-To: <1376987932-5540-2-git-send-email-Ying.Liu@freescale.com>
References: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com>
	<1376987932-5540-2-git-send-email-Ying.Liu@freescale.com>
Date: Tue, 20 Aug 2013 12:40:52 -0300
Message-ID: <CAOMZO5Afjp-zPzUaNE63L7Y2LjZbSrLupAJ_jFnf1Gg1+hx0Nw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: imx6q: refactor some ldb related clocks
From: Fabio Estevam <festevam@gmail.com>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 5:38 AM, Liu Ying <Ying.Liu@freescale.com> wrote:

> diff --git a/Documentation/devicetree/bindings/clock/imx6q-clock.txt b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
> index 5a90a72..90e923e 100644
> --- a/Documentation/devicetree/bindings/clock/imx6q-clock.txt
> +++ b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
> @@ -89,8 +89,6 @@ clocks and IDs.
>         gpu3d_shader            74
>         ipu1_podf               75
>         ipu2_podf               76
> -       ldb_di0_podf            77
> -       ldb_di1_podf            78
>         ipu1_di0_pre            79
>         ipu1_di1_pre            80
>         ipu2_di0_pre            81

This causes a 'hole' in the clock numbering scheme: 74, 75, 76, 79, 80, etc
