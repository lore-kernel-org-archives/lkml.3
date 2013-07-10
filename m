Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3GJCye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 22:54:34 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:30865
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753627Ab3GJCyd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 22:54:33 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc89bhzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kz8dhzz2dh2a8h668h839h941hd25he5bhf0ah1269h1288h12a5h12a9h12bdh12e1h1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <51DCCDD2.707@freescale.com>
Date: Wed, 10 Jul 2013 10:58:26 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] of: match the compatible in the order set by the dts
 file
References: <1373013818-11365-1-git-send-email-b32955@freescale.com>	<20130709070541.GQ516@pengutronix.de>	<51DBBFDA.70302@freescale.com>	<20130709075124.GR516@pengutronix.de>	<51DBC58D.90002@freescale.com> <CAL_JsqL4ABJCQXveSAMZKOiHwJi=w8zFYjg3DV7kqEEcCXQJcw@mail.gmail.com>
In-Reply-To: <CAL_JsqL4ABJCQXveSAMZKOiHwJi=w8zFYjg3DV7kqEEcCXQJcw@mail.gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年07月09日 20:03, Rob Herring 写道:
> the same and that is the assumption. Matching is not just based on
> compatible properties and your patch does not handle the other cases.
Could you show a example of "the other cases"?

After this patch,

[1] the matching will first check the @match->type and @match->name,
if we can match the @match->type or @match->name, return the match
immediately.

[2] If [1] fails, we will check the compatible properties.



thanks
Huang Shijie



