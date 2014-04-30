Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbaD3ORI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:17:08 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:50520
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758905AbaD3ORH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:17:07 -0400
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V1 net-next 1/1] hyperv: Enable sendbuf mechanism on the
 send path
Thread-Topic: [PATCH V1 net-next 1/1] hyperv: Enable sendbuf mechanism on
 the send path
Thread-Index: AQHPXzK1xiTkjzdkc0SXAOin2nil25sqPr8Q
Date: Wed, 30 Apr 2014 14:17:04 +0000
Message-ID: <7a7fd7286bc44121839ec68c8d1458b2@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1398288285-16268-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1398288285-16268-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(51704005)(199002)(189002)(13464003)(77982001)(76482001)(76576001)(81542001)(46102001)(81342001)(2201001)(92566001)(4396001)(86612001)(86362001)(99396002)(19580395003)(99286001)(19580405001)(83322001)(31966008)(80976001)(85852003)(83072002)(33646001)(101416001)(74662001)(74502001)(50986999)(1511001)(20776003)(77096999)(79102001)(54356999)(76176999)(66066001)(80022001)(2656002)(87936001)(74316001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:B6DF7906.B933ED3A.B1F023DF.C2E27BB0.201D3;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Wednesday, April 23, 2014 2:25 PM
> To: davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Cc: KY Srinivasan
> Subject: [PATCH V1 net-next 1/1] hyperv: Enable sendbuf mechanism on the
> send path
> 
> We send packets using a copy-free mechanism (this is the Guest to Host
> transport via VMBUS). While this is obviously optimal for large packets, it may
> not be optimal for small packets. Hyper-V host supports a second mechanism
> for sending packets that is "copy based". We implement that mechanism in
> this patch.
> 
> In this version of the patch I have addressed a comment from David Miller.

David,

Please let me know if there is some other issue you want addressed in this patch.

Regards,

K. Y
