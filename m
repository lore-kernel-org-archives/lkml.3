Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbaA0V4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 16:56:00 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.28]:30672 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbaA0Vz6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 16:55:58 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: KY Srinivasan <kys@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] hyperv: Add support for physically
 discontinuous receive buffer
Thread-Topic: [PATCH net-next] hyperv: Add support for physically
 discontinuous receive buffer
Thread-Index: AQHPDYLf/ncyAhKSa0a/KsTaDpfeiJqFW9eAgAjb6ECAAIw/AIAKckiQgACIbwD//3r0oA==
Date: Mon, 27 Jan 2014 21:55:27 +0000
Message-ID: <2c34baaad4eb4aab83f5b54eb982b662@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <5f60b6bd1ea84eadbb730c7ea9d3d4d5@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	<18b9150b090043b7b296593af994f8ee@BY2PR03MB299.namprd03.prod.outlook.com>
	<0671791e2ca8487a86a551eadf2e2bcd@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140127.135036.201976640275761993.davem@davemloft.net>
In-Reply-To: <20140127.135036.201976640275761993.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(51704005)(377454003)(164054003)(13464003)(199002)(189002)(90146001)(85852003)(83072002)(56816005)(92566001)(46102001)(2656002)(85306002)(74662001)(74502001)(31966008)(44976005)(19580395003)(83322001)(19580405001)(47446002)(87936001)(6806004)(53806001)(54356001)(51856001)(23726002)(69226001)(65816001)(81342001)(80022001)(66066001)(33646001)(87266001)(46406003)(81542001)(76786001)(74366001)(59766001)(80976001)(93136001)(77982001)(76796001)(50466002)(54316002)(56776001)(76482001)(93886001)(94316002)(74706001)(47976001)(50986001)(4396001)(47736001)(93516002)(49866001)(81686001)(81816001)(47776003)(63696002)(20776003)(79102001)(74876001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB593;H:hybrid.exchange.microsoft.com;CLIP:131.107.159.99;FPR:BC82F296.34D34C3A.7DF0319F.C2E21BF3.20176;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0104247462
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Monday, January 27, 2014 4:51 PM
> To: Haiyang Zhang
> Cc: KY Srinivasan; netdev@vger.kernel.org; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Add support for physically discontinuous
> receive buffer
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Mon, 27 Jan 2014 21:47:43 +0000
> 
> > So, could this patch be taken first?
> 
> You always need to resend patches that I've originally rejected and you've
> made arguments for.

Sure, I will re-send it now.

Thanks,
- Haiyang
