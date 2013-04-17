Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936305Ab3DQCpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 22:45:42 -0400
Received: from [216.32.180.189] ([216.32.180.189]:8329 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S936243Ab3DQCpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 22:45:41 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371Ic89bh542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h941hd25hf0ah1269h1288h12a5h12a9h12bdh12e1h137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Tang Yuantian-B29983 <B29983@freescale.com>
To: Timur Tabi <timur@tabi.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: RE: [PATCH v2] of/base: release the node correctly in
 of_parse_phandle_with_args()
Thread-Topic: [PATCH v2] of/base: release the node correctly in
 of_parse_phandle_with_args()
Thread-Index: AQHONaImIE34onvqCEuo3S6bpDZbgJjYwj+AgAD5nkA=
Date: Wed, 17 Apr 2013 02:44:27 +0000
Message-ID: <D07C73A334FF604B95B3CBD2A545D07B0B1456B8@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1365564999-24427-1-git-send-email-Yuantian.Tang@freescale.com>
 <CAOZdJXW8qKccGKic3R4o1aqJdbfHcBoAp62B4HPFnF=sUAEvuQ@mail.gmail.com>
In-Reply-To: <CAOZdJXW8qKccGKic3R4o1aqJdbfHcBoAp62B4HPFnF=sUAEvuQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.128]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3H2jkfO006854

> -----Original Message-----
> From: Timur Tabi [mailto:timur@tabi.org]
> Sent: 2013Äê4ÔÂ16ÈÕ 19:37
> To: Tang Yuantian-B29983
> Cc: Grant Likely; devicetree-discuss; linuxppc-dev@lists.ozlabs.org; lkml;
> Rob Herring
> Subject: Re: [PATCH v2] of/base: release the node correctly in
> of_parse_phandle_with_args()
> 
> On Tue, Apr 9, 2013 at 10:36 PM,  <Yuantian.Tang@freescale.com> wrote:
> >
> > +                       /* Found it! return success */
> 
> I'm pretty sure this comment is in the wrong place.

It is not perfect, but acceptable.

-Yuantian

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
