Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab3LSTg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:36:57 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.93]:34361 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089Ab3LSTgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:36:55 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Daniel Borkmann <dborkman@redhat.com>
CC: Ben Hutchings <bhutchings@solarflare.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] hyperv: Add support for Virtual Receive Side
 Scaling (vRSS)
Thread-Topic: [PATCH net-next] hyperv: Add support for Virtual Receive Side
 Scaling (vRSS)
Thread-Index: AQHO/DjpLyfIXxkiYUqDQo2oHD6XuZpcUhsA//+GhuCAAIn5gP//g6Ig
Date: Thu, 19 Dec 2013 19:21:31 +0000
Message-ID: <6ee28c6a94e74c958ee96c3547741fb9@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1387405262-18334-1-git-send-email-haiyangz@microsoft.com>
 <1387475178.1876.29.camel@bwh-desktop.uk.level5networks.com>
 <ff7f7541d0164d408b3a4278569c593a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <52B33EC1.5040901@redhat.com>
In-Reply-To: <52B33EC1.5040901@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(479174003)(13464003)(377454003)(51704005)(164054003)(189002)(199002)(24454002)(76482001)(66066001)(63696002)(47776003)(54316002)(74706001)(6806004)(50986001)(47446002)(20776003)(65816001)(80022001)(46102001)(47736001)(2656002)(47976001)(56776001)(49866001)(59766001)(85306002)(87266001)(83072002)(85852003)(77982001)(80976001)(81686001)(74876001)(81342001)(81542001)(74502001)(81816001)(53806001)(4396001)(83322001)(79102001)(69226001)(19580395003)(19580405001)(76796001)(76786001)(74662001)(50466002)(44976005)(90146001)(31966008)(51856001)(54356001)(87936001)(74366001)(33646001)(56816005)(23676002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB597;H:hybrid.exchange.microsoft.com;CLIP:131.107.159.99;FPR:;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 006546F32A
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJJb1AY007296



> -----Original Message-----
> From: Daniel Borkmann [mailto:dborkman@redhat.com]
> Sent: Thursday, December 19, 2013 1:45 PM
> To: Haiyang Zhang
> Cc: Ben Hutchings; davem@davemloft.net; netdev@vger.kernel.org; KY
> Srinivasan; olaf@aepfle.de; jasowang@redhat.com; linux-
> kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Add support for Virtual Receive Side
> Scaling (vRSS)
> 
> On 12/19/2013 07:36 PM, Haiyang Zhang wrote:
> 
> > Thank you for the suggestions! I will re-write the send queue
> > selection, enhance the hash calculation, also fix the initialization sequence.
> 
> Btw, Toeplitz hash function should either go into lib/hash.c as well or
> include/linux/hash.h to avoid ending up w/ various implementations in multiple
> places.

Will do. 

Thanks,
- Haiyang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
