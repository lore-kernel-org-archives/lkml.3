Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbaGPRak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:30:40 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:12353
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751477AbaGPRai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:30:38 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Hannes Reinecke <hare@suse.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH V3 1/7] Drivers: scsi: storvsc: Change the limits to
 reflect the values on the host
Thread-Topic: [PATCH V3 1/7] Drivers: scsi: storvsc: Change the limits to
 reflect the values on the host
Thread-Index: AQHPneiplMkhhkmHV0+QeEPfqDp/tZufGiWAgAAl24CAAAeTgIADsoeAgAAA5ACAAABIMA==
Date: Wed, 16 Jul 2014 17:30:14 +0000
Message-ID: <758c5a92ec504dd2a2d431ce3e9bd92b@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com>
 <1405183712-23967-1-git-send-email-kys@microsoft.com>
 <53C37575.5030808@suse.de> <20140714083047.GB22715@infradead.org>
 <53C39B91.4010000@suse.de>
 <e6f205c16ba2414ab5645977ac038e6c@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140716172850.GA10159@infradead.org>
In-Reply-To: <20140716172850.GA10159@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.159.47]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(24454002)(377454003)(51704005)(189002)(199002)(74316001)(107046002)(86612001)(99286002)(83072002)(95666004)(93886003)(2656002)(106116001)(46102001)(86362001)(74662001)(76176999)(106356001)(33646002)(74502001)(76576001)(19580395003)(110136001)(101416001)(76482001)(77096002)(20776003)(54356999)(85852003)(80022001)(66066001)(92566001)(21056001)(105586002)(31966008)(83322001)(50986999)(19580405001)(79102001)(85306003)(64706001)(99396002)(81342001)(4396001)(81542001)(77982001)(87936001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0709;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 16, 2014 10:29 AM
> To: KY Srinivasan
> Cc: Hannes Reinecke; jasowang@redhat.com; apw@canonical.com; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; linux-scsi@vger.kernel.org;
> stable@vger.kernel.org
> Subject: Re: [PATCH V3 1/7] Drivers: scsi: storvsc: Change the limits to reflect
> the values on the host
> 
> On Wed, Jul 16, 2014 at 05:26:48PM +0000, KY Srinivasan wrote:
> > Christoph,
> >
> > Is this patch-set ready to be checked in. Let me know if you want me
> > to make any further corrections.
> 
> Hi Ky,
> 
> I've applied it locally, but I'm still waiting on reviews for two important core
> fixes before pushing out the updated tree.

Thank you.

K. Y
