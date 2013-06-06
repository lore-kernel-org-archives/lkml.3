Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3FFCRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 22:17:50 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:8482
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059Ab3FFCRt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 22:17:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc89bhzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kz8dhzz2dh2a8h668h839h941hd25he5bhf0ah1269h1288h12a5h12a9h12bdh12e1h1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <51AFF1FB.1070100@freescale.com>
Date: Thu, 6 Jun 2013 10:20:43 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>, <linux-mtd@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Imre Deak <imre.deak@intel.com>
Subject: Re: [PATCH 3/3] mtd: cfi_cmdset_0002: increase do_write_buffer()
 timeout
References: <1370310406-413-1-git-send-email-computersforpeace@gmail.com>	<1370310406-413-3-git-send-email-computersforpeace@gmail.com>	<51AD9140.90500@freescale.com>	<CAN8TOE9UDGuQd9AbE-4UVcAiqCFpqhY=fX+LbrDybdgr16THdQ@mail.gmail.com> <CAN8TOE8FRtQupXwvAtrVSN-C-nQz-XgOW7OA5C=XRs9YmCwTkg@mail.gmail.com>
In-Reply-To: <CAN8TOE8FRtQupXwvAtrVSN-C-nQz-XgOW7OA5C=XRs9YmCwTkg@mail.gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年06月06日 05:08, Brian Norris 写道:
> Note that a 2-jiffy timeout does not, in fact, totally resolve my
> problems; with a timeout of 2 jiffies, I still get a timeout that
> (according to getnstimeofday()) occurs after only 56us. It does
since the 2-jiffy does not resolve your problem, i suggest you try the
latest linux-next
tree.


thanks
Huang Shijie

