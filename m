Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaGZRRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 13:17:24 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:10447
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751532AbaGZRRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 13:17:22 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Sitsofe Wheeler <sitsofe@gmail.com>, Christoph Hellwig <hch@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Thread-Topic: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Thread-Index: AQHPqPJOfmLHK0GnrkSEOCNbbvYH8Zuyl+Mw
Date: Sat, 26 Jul 2014 17:17:17 +0000
Message-ID: <cc4a3fd5451242739929d266b88fa8fa@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140724122223.GA31798@sucs.org>
	<yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
	<yq1egxakb0z.fsf@sermon.lab.mkp.net>
	<16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq1wqb1gyw1.fsf@sermon.lab.mkp.net>
	<e931486ef33b4e45bfebf2ab1b1b3037@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <yq17g30dprc.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq17g30dprc.fsf@sermon.lab.mkp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(199002)(377454003)(189002)(51704005)(107046002)(76482001)(95666004)(106116001)(99286002)(110136001)(76576001)(4396001)(50986999)(33646002)(76176999)(46102001)(105586002)(54356999)(92566001)(85852003)(19580405001)(20776003)(66066001)(81542001)(31966008)(86362001)(81342001)(80022001)(74502001)(77982001)(93886003)(77096002)(101416001)(19580395003)(85306003)(86612001)(83322001)(83072002)(74662001)(21056001)(79102001)(2656002)(74316001)(106356001)(99396002)(87936001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Saturday, July 26, 2014 9:55 AM
> To: KY Srinivasan
> Cc: Martin K. Petersen; Sitsofe Wheeler; Christoph Hellwig;
> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; apw@canonical.com;
> jasowang@redhat.com; jbottomley@parallels.com; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
> 
> >>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:
> 
> >> The LBP VPD page flags UNMAP as being supported. Do you actually
> >> support UNMAP to DSM TRIM SCSI-ATA translation?
> 
> KY> I have been told by the Windows folks that this is done. I am trying
> KY> to get additional details.
> 
> Great! I'd just like to have a reasonable level of confidence in what's
> happening down the stack before I entertain turning something on that's not
> being properly advertised.

As I look at the output of inquiry between Linux on Hyper-V and native Linux, is not specifying
conformance level the main issue?

K. Y
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
