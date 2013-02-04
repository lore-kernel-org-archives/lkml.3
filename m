Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3BDIqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:46:52 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:33907
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753691Ab3BDIqv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:46:51 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(z3121kz98dIc89bh936eIzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h1155h)
Message-ID: <510F7577.7070300@freescale.com>
Date: Mon, 4 Feb 2013 16:46:47 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: <artem.bityutskiy@linux.intel.com>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <shmulik.ladkani@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] mtd: add new fields to nand_flash_dev{}
References: <1359007901-26464-1-git-send-email-b32955@freescale.com>	 <1359007901-26464-2-git-send-email-b32955@freescale.com>	 <5105DD0E.1010500@freescale.com> <1359967368.13791.22.camel@sauron.fi.intel.com>
In-Reply-To: <1359967368.13791.22.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月04日 16:42, Artem Bityutskiy 写道:
> On Mon, 2013-01-28 at 10:06 +0800, Huang Shijie wrote:
>>> +     unsigned int id_len;
>>> +     unsigned long oobsize;
>>> +     unsigned long ecc_len;
>> I think it's better to submit another patch set to solve the ECC
>> problem.
> Would you please strip the cited text when bottom-posting - this would
> be a lot mailing-list-friendly.

ok. I will keep in mind about this.

thanks
Huang Shijie


