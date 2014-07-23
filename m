Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbaGWPkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:40:41 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:15006
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757640AbaGWPkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:40:40 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>, Sitsofe Wheeler <sitsofe@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Hannes Reinecke (hare@suse.de)" <hare@suse.de>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Thread-Topic: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Thread-Index: AQHPpS/NDcbvaizdgkyl0kJjZb6qA5utcLIAgAAdzgCAABGsgIAAFRkAgAAYfDA=
Date: Wed, 23 Jul 2014 15:40:37 +0000
Message-ID: <1ed4589a09b74935afd7046fb1a85d2c@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723100448.GA2540@sucs.org> <20140723115128.GB16881@infradead.org>
 <20140723125443.GA16103@sucs.org> <20140723141014.GA892@infradead.org>
In-Reply-To: <20140723141014.GA892@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(377454003)(13464003)(24454002)(189002)(199002)(76576001)(79102001)(85852003)(95666004)(83072002)(81542001)(92566001)(93886003)(81342001)(54356999)(19580395003)(76482001)(50986999)(76176999)(99286002)(85306003)(101416001)(99396002)(105586002)(80022001)(77096002)(4396001)(86362001)(2656002)(31966008)(20776003)(19580405001)(87936001)(74316001)(77982001)(83322001)(33646002)(106116001)(66066001)(64706001)(21056001)(74662001)(107046002)(86612001)(74502001)(106356001)(46102001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 23, 2014 7:10 AM
> To: Sitsofe Wheeler
> Cc: KY Srinivasan; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.com;
> apw@canonical.com; jasowang@redhat.com; jbottomley@parallels.com;
> linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
> 
> On Wed, Jul 23, 2014 at 01:54:43PM +0100, Sitsofe Wheeler wrote:
> > That's good to know (I was worried the device would not be detected as
> > supporting discard because it doesn't report lbpme and doesn't declare
> > a conformance version (see below)).
> 
> Ok, that makes things worse - you might be able to force it through sysfs,
> though.
> 
> > Is there a tree with all these updates in or do they need to be pieced
> > together from this email thread?
> 
> I'm picking this up for my scsi-queue tree.  Still need a review for the patch
> we're replying to before that one can go in, though.

Hannes, could you please review this patch. Christoph, other than the review of this patch,
Is there something you want done before these can be committed.

Regards,

K. Y
> 
> > Additionally is it worth quirking sd_try_rc16_first on when
> > BLIST_TRY_VPD_PAGES is present?
> 
> Sounds reasonable to me.
