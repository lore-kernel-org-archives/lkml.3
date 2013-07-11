Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab3GKCKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:10:52 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:33596
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754922Ab3GKCKu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:10:50 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zzc89bh1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz8275dhz2dh2a8h668h839h941hd25he5bhf0ah1269h1288h12a5h12a9h12bdh12e1h1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <51DE1514.20903@freescale.com>
Date: Thu, 11 Jul 2013 10:14:44 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 06/12] drivers/mtd/nand/gpmi-nand: don't use devm_pinctrl_get_select_default()
 in probe
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de> <1373471889-18107-6-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1373471889-18107-6-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年07月10日 23:57, Wolfram Sang 写道:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> we can rely on device core for setting the default pins. Compile tested only.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> --- 
i remember Fabio had already sent a similar patch about this issue.

thanks
Huang Shijie

