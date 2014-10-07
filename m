Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaJGRop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:44:45 -0400
Received: from mail-bl2on0108.outbound.protection.outlook.com ([65.55.169.108]:32064
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754563AbaJGRol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:44:41 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "hare@suse.de" <hare@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/2] Drivers: scsi: storvsc: Fix issues with
 hot-add/remove of LUNs
Thread-Topic: [PATCH 0/2] Drivers: scsi: storvsc: Fix issues with
 hot-add/remove of LUNs
Thread-Index: AQHP2Mc/+A7SUQCDKE6qLSHJTNewEZwk+xFQ
Date: Tue, 7 Oct 2014 17:44:38 +0000
Message-ID: <65593e832b5b4da184470799eac9e384@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
 <20140925134726.GA26946@infradead.org>
In-Reply-To: <20140925134726.GA26946@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e0:ee43::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;
x-forefront-prvs: 035748864E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(13464003)(377454003)(51704005)(24454002)(97736003)(15202345003)(120916001)(108616004)(33646002)(21056001)(46102003)(76482002)(80022003)(19580395003)(54356999)(99396003)(86612001)(76176999)(50986999)(101416001)(76576001)(74316001)(15975445006)(87936001)(105586002)(99286002)(31966008)(106116001)(85852003)(2656002)(106356001)(110136001)(95666004)(4396001)(64706001)(107046002)(92566001)(19580405001)(20776003)(77096002)(86362001)(85306004)(122556002)(40100002)(3826002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, September 25, 2014 6:47 AM
> To: KY Srinivasan
> Cc: hare@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 0/2] Drivers: scsi: storvsc: Fix issues with hot-
> add/remove of LUNs
> 
> So can anywayone give me a review for those two patches?

Did you get the reviews?

K. Y
> 
> On Sat, Aug 16, 2014 at 08:09:14PM -0700, K. Y. Srinivasan wrote:
> > This patch-set addresses issues with LUN hot-add and remove. When the
> > host notifies the guest that a scan is needed, scan the host. Also,
> > prior to discovering new devices that may have been added, ensure we
> > handle the LUN remove case first.
> >
> > K. Y. Srinivasan (2):
> >   Drivers: scsi: storvsc: In responce to a scan event, scan the host
> >   Drivers: scsi: storvsc: Force discovery of LUNs that may have been
> >     removed.
> >
> >  drivers/scsi/storvsc_drv.c |   43 ++++++++++++++++++++++++++++++++-
> ----------
> >  1 files changed, 32 insertions(+), 11 deletions(-)
> >
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---
