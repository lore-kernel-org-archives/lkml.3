Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab3DZGXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:23:11 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:10932
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757673Ab3DZGXJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:23:09 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z3121kzc89bhda00hzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kz8dhzz2dh2a8h668h839h941hd25he5bhf0ah1269h1288h12a5h12a9h12bdh12e1h1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1155h)
Message-ID: <517A1DB2.9030606@freescale.com>
Date: Fri, 26 Apr 2013 14:24:50 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: <dwmw2@infradead.org>, <dedekind1@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 6/9] mtd: add a new field for ecc info in the nand_flash_dev{}
References: <1366707297-31309-1-git-send-email-b32955@freescale.com>	<1366707297-31309-7-git-send-email-b32955@freescale.com>	<CAN8TOE_5CeJfGpgJtKBXmb5ai3w9dZ8juk5GdQhRTZQ7MPKbZw@mail.gmail.com>	<5178EFC9.9080207@freescale.com> <CAN8TOE9VfdC38wJO0=_+nZ2d7qz3citSb7yVKsUj3Zsz91WpWA@mail.gmail.com>
In-Reply-To: <CAN8TOE9VfdC38wJO0=_+nZ2d7qz3citSb7yVKsUj3Zsz91WpWA@mail.gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年04月26日 14:15, Brian Norris 写道:
> How does that look? It's actually quite similar to the construct Artem
> used with mfr_id and dev_id, except that we give the struct a name.
> And this time, it actually compiles!
>
It's ok to me. :)

I will use it in the next version.

thanks
Huang Shijie

