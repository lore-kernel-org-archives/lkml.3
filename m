Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaI2CBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 22:01:36 -0400
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:23328
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753310AbaI2CBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 22:01:34 -0400
X-Greylist: delayed 870 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Sep 2014 22:01:34 EDT
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
Thread-Index: AQHP2Mc/+A7SUQCDKE6qLSHJTNewEZwXXHZw
Date: Mon, 29 Sep 2014 01:47:02 +0000
Message-ID: <00898bd39d704b06a15be3a984589259@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
 <20140925134726.GA26946@infradead.org>
In-Reply-To: <20140925134726.GA26946@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [131.107.174.160]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0709;
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 034902F5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(189002)(199003)(24454002)(13464003)(51704005)(21056001)(31966008)(77096002)(85306004)(108616004)(95666004)(105586002)(83322001)(99286002)(97736003)(19580395003)(106116001)(15975445006)(19580405001)(20776003)(106356001)(64706001)(54356999)(66066001)(50986999)(74316001)(107046002)(76176999)(83072002)(90102001)(4396001)(76576001)(79102003)(85852003)(110136001)(92566001)(80022003)(74502003)(86612001)(87936001)(2656002)(76482002)(101416001)(120916001)(33646002)(10300001)(99396003)(81342003)(77982003)(46102003)(74662003)(81542003)(15202345003)(86362001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0709;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
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

Olaf,

Could you review these patches.

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
