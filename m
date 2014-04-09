Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899AbaDISkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:40:03 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:6365
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933323AbaDISkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:40:00 -0400
From: KY Srinivasan <kys@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH net 3/3] Drivers: net: hyperv: Address UDP checksum
 issues
Thread-Topic: [PATCH net 3/3] Drivers: net: hyperv: Address UDP checksum
 issues
Thread-Index: AQHPU1uXnPiEDJtl6E20Y4v9ie8cnpsJg+aAgAAN2TCAAAzmgIAAAJ/w
Date: Wed, 9 Apr 2014 18:39:57 +0000
Message-ID: <b9662fd6593d462e83c5b88af75d5f2e@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1396986371-12137-4-git-send-email-kys@microsoft.com>
	<20140409.130111.1002891296248446198.davem@davemloft.net>
	<4ae24ae5c6ea45c399e7be03c69dc442@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140409.143655.2112963679697366338.davem@davemloft.net>
In-Reply-To: <20140409.143655.2112963679697366338.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ed43::3]
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(13464003)(189002)(199002)(51704005)(20776003)(76576001)(86362001)(77982001)(99396002)(81342001)(83072002)(4396001)(76482001)(33646001)(19580395003)(46102001)(74662001)(92566001)(80976001)(19580405001)(31966008)(79102001)(81542001)(85852003)(74502001)(74316001)(83322001)(87936001)(80022001)(2656002)(50986999)(76176999)(54356999)(77096999)(3826001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:EBFFC834.B0036E1A.3DE15B9E.C0E2CB5A.201D8;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Wednesday, April 9, 2014 11:37 AM
> To: KY Srinivasan
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH net 3/3] Drivers: net: hyperv: Address UDP checksum
> issues
> 
> From: KY Srinivasan <kys@microsoft.com>
> Date: Wed, 9 Apr 2014 18:08:47 +0000
> 
> > Thanks Dave. I will COW the SKB before changing the checksum value. I
> > do have a question though.  I looked at a bunch of hardware drivers
> > and they modify the header information, specially checksum field and I
> > could not see where they had COWed the skb. I was grepping for skb_cow
> > in these drivers.
> 
> Look for skb_cow_head(), for example, the tg3.c driver uses this.
> 
Thank you. I will update this patch. Do you want me to resend the whole set or just
this patch.

K. Y
