Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3EVCM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 22:12:56 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:40817
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818Ab3EVCMz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 22:12:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(z616jzc89bh1447Idf9Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kz8dhzz2dh2a8h668h839h941hd25he5bhf0ah1269h1288h12a5h12a9h12bdh12e1h1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <519C2A3C.20709@freescale.com>
Date: Wed, 22 May 2013 10:15:24 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Vikram Narayanan <vikram186@gmail.com>
CC: Brian Norris <computersforpeace@gmail.com>, <dwmw2@infradead.org>,
        <dedekind1@gmail.com>, <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 05/10 fix] mtd: get the ECC info from the Extended
 Parameter Page
References: <51966AA7.7050007@gmail.com> <1369015705-4720-1-git-send-email-b32955@freescale.com> <5199BD45.5090100@gmail.com> <5199C159.6020401@freescale.com> <CAHwEkO2Wn_jLCS-4-1p6Mks-0q3Dy_kzR-j-xtX_oOAOive2VQ@mail.gmail.com>
In-Reply-To: <CAHwEkO2Wn_jLCS-4-1p6Mks-0q3Dy_kzR-j-xtX_oOAOive2VQ@mail.gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月22日 00:35, Vikram Narayanan 写道:
> What if we do like this? Let's do a strict check for now. ("EPPS")
> If some chip manufacturer had _strictly_ followed the spec, i.e., any
> two bytes are valid.
> Then make the code comply with the spec.
> Any comments?
Agreed.

I will send a new patch for this.

thanks for the comment.

Huang Shijie

