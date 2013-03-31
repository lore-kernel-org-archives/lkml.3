Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab3CaNM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 09:12:58 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:54779
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011Ab3CaNM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 09:12:56 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sun, 31 Mar 2013 21:12:56 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Lars Poeschel <poeschel@lemonage.de>
Subject: Re: [PATCH 3/6] i2c: Ignore return value of i2c_del_adapter()
Message-ID: <20130331131254.GA17773@S2101-09.ap.freescale.net>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
 <1362853009-20789-4-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1362853009-20789-4-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 07:16:46PM +0100, Lars-Peter Clausen wrote:
> i2c_del_adapter() always returns 0. So all checks testing whether it will be
> non zero will always evaluate to false and the conditional code is dead code.
> This patch updates all callers of i2c_del_mux_adapter() to ignore the return
> value and assume that it will always succeed (which it will). In a subsequent
> patch the return type of i2c_del_adapter() will be made void.
> 
...
> Cc: Shawn Guo <shawn.guo@linaro.org>
...
>  drivers/i2c/busses/i2c-mxs.c                 |  5 +----

Acked-by: Shawn Guo <shawn.guo@linaro.org>

