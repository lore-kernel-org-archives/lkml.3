Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaCGJHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:07:50 -0500
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:38573
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751013AbaCGJHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:07:46 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on the number
 of pfns we can handle
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on the
 number of pfns we can handle
Thread-Index: AQHPOc2oQ3eOFqZTbkO5srnGB9wLTZrVR3eAgAAMhPA=
Date: Fri, 7 Mar 2014 09:07:42 +0000
Message-ID: <9037d4ef9c174fb280f00f22912c3d12@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1394176508-1439-1-git-send-email-kys@microsoft.com>
 <20140307081627.GC29018@mwanda>
In-Reply-To: <20140307081627.GC29018@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [117.192.103.21]
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(377454003)(24454002)(13464003)(51704005)(56816005)(90146001)(33646001)(74706001)(87936001)(56776001)(95666003)(74316001)(97336001)(97186001)(4396001)(77982001)(94946001)(69226001)(19580405001)(81686001)(19580395003)(83322001)(49866001)(74876001)(54316002)(81342001)(51856001)(86612001)(80976001)(50986001)(81542001)(66066001)(54356001)(2656002)(92566001)(76786001)(94316002)(76796001)(46102001)(95416001)(76576001)(53806001)(85852003)(83072002)(76482001)(47446002)(79102001)(59766001)(74502001)(65816001)(87266001)(47736001)(47976001)(80022001)(63696002)(74366001)(81816001)(93136001)(86362001)(31966008)(85306002)(93516002)(74662001)(29543002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB596;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:117.192.103.21;FPR:8AFECDF2.9CD3AFEA.F360B3BC.C4ACB9C8.201BF;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Friday, March 7, 2014 1:46 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on the number
> of pfns we can handle
> 
> On Thu, Mar 06, 2014 at 11:15:08PM -0800, K. Y. Srinivasan wrote:
> > Increase the maximum number of pfns we can handle is a single vmbus
> packet.
>                                                     ^^ in

Thanks Dan. I am traveling in India and it shows. I have already sent a corrected patch.

> >
> 
> What are the user visible effects of this patch?
The current code will drop these packets that have more PFNs than the limit.
Upping the limit will mitigate this problem.

Regards,

K. Y

> 
> regards,
> dan carpenter

