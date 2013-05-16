Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab3EPIIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:08:32 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:8440
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399Ab3EPIIZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:08:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zzc89bhda00hdc73hzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h668h839h93fhe5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1889i1155h)
Message-ID: <51949484.2080907@freescale.com>
Date: Thu, 16 May 2013 16:10:44 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: Huang Shijie <shijie8@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Export the ecc step size to user applications
References: <1368607606-4344-1-git-send-email-b32955@freescale.com>	 <1368619642.15764.96.camel@sauron.fi.intel.com>	 <CAMiH66GygmwvfZrwys7RoeoY4Q_fFkfbiZF_pJN4RxQBPaz0fw@mail.gmail.com> <1368688777.15764.175.camel@sauron.fi.intel.com>
In-Reply-To: <1368688777.15764.175.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月16日 15:19, Artem Bityutskiy 写道:
> Also, surely the things you expose are the real ECC step and ECC
> strength? I think the datasheet ones in your other patch-set should be
yes. I am sure of that.
I need the _real_ ECC step and ECC strength.

thanks
Huang Shijie

