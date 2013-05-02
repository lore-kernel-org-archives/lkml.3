Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3EBGqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:46:19 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:56893
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab3EBGqR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:46:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc89bhzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <51820C2C.1080404@freescale.com>
Date: Thu, 2 May 2013 14:48:12 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Gupta, Pekon" <pekon@ti.com>
CC: "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH V4 5/9] mtd: replace the hardcode with the onfi_feature()
References: <1366967337-5534-1-git-send-email-b32955@freescale.com> <1366967337-5534-6-git-send-email-b32955@freescale.com> <20980858CB6D3A4BAE95CA194937D5E73E9BF544@DBDE04.ent.ti.com> <5181CC19.8000904@freescale.com> <20980858CB6D3A4BAE95CA194937D5E73E9C09FC@DBDE04.ent.ti.com> <51820127.5060003@freescale.com> <20980858CB6D3A4BAE95CA194937D5E73E9C0A2F@DBDE04.ent.ti.com>
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73E9C0A2F@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月02日 14:17, Gupta, Pekon 写道:
> [Pekon]: onfi_feature() is actually not useful unless someone re-scans the
I do not think so. :)

I think the onfi_feature() is useful in the future.
I only add the two feauture for this helper:
   [1] 16-bit and
   [2] extended parameter page

But in actually, we may add more feature to this helper, such as 
_synchronous_.
For example, some driver may support the synchronous mode for the ONFI nand.
We can use this onfi_feature() in the driver to check if the onfi nand 
supports this
synchronous feature.

Add this helper makes the code more readable, though we introduce a 
little redandancy.


thanks
Huang Shijie



