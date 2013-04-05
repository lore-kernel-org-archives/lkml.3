Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161861Ab3DEOOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 10:14:07 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.90]:48252 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161773Ab3DEOOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:14:05 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Richard Genoud <richard.genoud@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: hv_netvsc: WARNING in softirq.c
Thread-Topic: hv_netvsc: WARNING in softirq.c
Thread-Index: AQHOFY6mlTKiRrtVMEyJsd7vlhJcdZiPmH8QgAFzAwCACDndgIABTiCAgBKwVACAGt/NAP//wE0w
Date: Fri, 5 Apr 2013 14:13:26 +0000
Message-ID: <401a73f632fd499fbc0eb9d4f662e833@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <20130228083437.GA28143@lnx-rg>
 <78fd1c1df13b449887de6e0b3505a988@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <CACQ1gAgyYp+Dxmk-0C3zfKK+CkEwQX51NvWjzkV7=8GC3CD=Qg@mail.gmail.com>
 <4147bb5a7cf547c19c6a5a6b459a957d@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <CACQ1gAi1NNwJ_QDp7ipjwdYCskENGN=N-j+TFD5aHX8DHnoBQA@mail.gmail.com>
 <CACQ1gAiadLrJQkDFe7_TEM_1OVSjECyewmxHyXvOcYCc7GLn_Q@mail.gmail.com>
 <CACQ1gAgh7QX=cDYsrw9J5qYNKYpgQ841QijA145TDO_Ae5EsQQ@mail.gmail.com>
In-Reply-To: <CACQ1gAgh7QX=cDYsrw9J5qYNKYpgQ841QijA145TDO_Ae5EsQQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.27;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(189002)(69226001)(4396001)(74662001)(47976001)(44976002)(47736001)(876001)(76482001)(47446002)(33646001)(50986001)(77982001)(621065001)(53806001)(16406001)(54316002)(46102001)(31966008)(81342001)(59766001)(49866001)(66066001)(56776001)(50466001)(51856001)(47776003)(65816001)(54356001)(80022001)(63696002)(20776003)(73894001)(56816002)(23676001)(74502001)(79102001)(81542001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2SR01MB608;H:hybrid.exchange.microsoft.com;RD:mail7.exchange.microsoft.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 08076ABC99
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r35EEAmx009618



> -----Original Message-----
> From: Richard Genoud [mailto:richard.genoud@gmail.com]
> Sent: Friday, April 05, 2013 7:00 AM
> To: Haiyang Zhang
> Cc: KY Srinivasan; devel@linuxdriverproject.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: hv_netvsc: WARNING in softirq.c
> 
> Ok, it has been a little bit more than 2 weeks now, and I did not see this
> warning any more, just the
> "hv_vmbus: child device vmbus_0_8 unregistered" sometimes.
> 
> so it seems to be fixed !
> 
> Thanks !
> 
> 
> Reported-by: Richard Genoud <richard.genoud@gmail.com>
> Tested-by: Richard Genoud <richard.genoud@gmail.com>
> 

Thank you! I will submit the patch soon.

- Haiyang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
