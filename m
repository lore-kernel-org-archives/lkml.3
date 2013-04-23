Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3DWCrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 22:47:42 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:32541
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754040Ab3DWCrk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 22:47:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z616jzc89bhda00hdc73hzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kz8dhzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1155h)
Message-ID: <5175F6B0.1080907@freescale.com>
Date: Tue, 23 Apr 2013 10:49:20 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: <dwmw2@infradead.org>, <dedekind1@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <shijie8@gmail.com>
Subject: Re: [PATCH v2 2/8] mtd: add a helper to get the supported features
 for ONFI nand
References: <1366616878-29481-1-git-send-email-b32955@freescale.com>	<1366616878-29481-3-git-send-email-b32955@freescale.com> <CAN8TOE8EwK1iaDOjBPpUhQmzn=AK-2LufufwwMON6gf=-zZa+Q@mail.gmail.com>
In-Reply-To: <CAN8TOE8EwK1iaDOjBPpUhQmzn=AK-2LufufwwMON6gf=-zZa+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年04月23日 05:04, Brian Norris 写道:
> return chip->onfi_version ? le16_to_cpu(chip->onfi_params.features) : 0;
it's ok to me. I will use 0 as the unknow feature in the next version.

thanks
Huang Shijie

