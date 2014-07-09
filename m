Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaGISkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:40:45 -0400
Received: from [207.46.163.188] ([207.46.163.188]:35605 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751294AbaGISkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:40:43 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Thread-Topic: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Thread-Index: AQHPmwbgHQRbrGSDW0yYxe5G8grckJuXbgyAgAClIWA=
Date: Wed, 9 Jul 2014 18:40:09 +0000
Message-ID: <651b6b11c6d6415cb0046ce03b6b2c63@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-7-git-send-email-kys@microsoft.com>
 <20140709084453.GG6012@infradead.org>
In-Reply-To: <20140709084453.GG6012@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(189002)(199002)(51704005)(24454002)(13464003)(50986999)(33646001)(87936001)(80022001)(101416001)(74316001)(20776003)(4396001)(85306003)(77982001)(66066001)(81342001)(2656002)(74662001)(110136001)(85852003)(95666004)(76176999)(19580395003)(106116001)(54356999)(99286002)(86362001)(79102001)(105586002)(92566001)(106356001)(76482001)(86612001)(81542001)(107046002)(74502001)(83072002)(21056001)(76576001)(19580405001)(64706001)(46102001)(99396002)(31966008)(83322001)(93886003)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 9, 2014 1:45 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
> 
> On Tue, Jul 08, 2014 at 05:46:51PM -0700, K. Y. Srinivasan wrote:
> > Correctly set SRB flags for all valid I/O directions. Some IHV drivers
> > on the Windows host require this.
> 
> What are IHV drivers?

If the target is a SAN device, the host simply passes the request over to the native driver stack on the host. Some specific hardware (IHV - independent hadware vendor) drivers on Windows require that SRB flags be correctly set in all cases.

Regards,

K. Y
> 
> 
> Otherwise looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
