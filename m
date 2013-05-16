Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab3EPKpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 06:45:31 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:51013 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751763Ab3EPKp0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 06:45:26 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z3121kzc89bhda00hdc73hzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <5194B919.8010405@freescale.com>
Date: Thu, 16 May 2013 18:46:49 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 01/11] mtd: add datasheet's ECC information to nand_chip{}
References: <1368607232-2210-1-git-send-email-b32955@freescale.com>			 <1368607232-2210-2-git-send-email-b32955@freescale.com>		 <1368619917.15764.99.camel@sauron.fi.intel.com>		 <51944184.7090107@freescale.com>	 <1368688465.15764.172.camel@sauron.fi.intel.com>	 <51949378.6020005@freescale.com> <1368696992.15764.188.camel@sauron.fi.intel.com>
In-Reply-To: <1368696992.15764.188.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月16日 17:36, Artem Bityutskiy 写道:
> May be, if these are not too long names. Or ecc_ds_strignth /
> ecc_ds_step, for example.
I prefer to the ecc_strength_ds/ecc_step_ds. :)

Huang Shijie

