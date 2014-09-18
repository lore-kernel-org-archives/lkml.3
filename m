Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbaIRQ7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:59:13 -0400
Received: from [207.46.100.148] ([207.46.100.148]:62470 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932173AbaIRQ7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:59:12 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>, Olaf Hering <ohering@suse.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Thread-Topic: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Thread-Index: AQHPxv6/GORoYjEt3E6tVTV95tJxCJvyCb0AgAWa0NCADWDJAIABCVuAgADQv4CAAFHlAIAAABxA
Date: Thu, 18 Sep 2014 16:44:24 +0000
Message-ID: <8eca1b3e8e4a4945a15a770b5700251b@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1409701396-20226-1-git-send-email-kys@microsoft.com>
 <20140905054014.GA11595@infradead.org>
 <155acb7b8a3d4532aaa280e44f62447f@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140917073324.GB23716@suse.com> <20140917232309.GA4554@infradead.org>
 <20140918115017.GA20884@suse.com> <20140918164324.GA12287@infradead.org>
In-Reply-To: <20140918164324.GA12287@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e0:ee43::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(377454003)(51704005)(13464003)(199003)(33646002)(19580395003)(74316001)(50986999)(86362001)(54356999)(93886004)(76176999)(92566001)(15202345003)(20776003)(4396001)(97736003)(15975445006)(64706001)(95666004)(83322001)(90102001)(77982003)(99396002)(77096002)(108616004)(19580405001)(46102003)(107046002)(74502003)(76576001)(81342003)(81542003)(79102003)(86612001)(101416001)(85852003)(105586002)(85306004)(21056001)(106116001)(76482002)(74662003)(80022003)(106356001)(83072002)(2656002)(31966008)(87936001)(26583001)(24736002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, September 18, 2014 9:43 AM
> To: Olaf Hering
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; jbottomley@parallels.com; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
> 
> On Thu, Sep 18, 2014 at 01:50:17PM +0200, Olaf Hering wrote:
> > On Wed, Sep 17, Christoph Hellwig wrote:
> >
> > > Also the two patches at
> > > http://thread.gmane.org/gmane.linux.drivers.driver-project.devel/562
> > > 42/
> >
> > Wasnt the outcome that this was a bad idea? Or at least doing it
> > globally is bad. In any case, its not something I can help with.
> 
> The outcome was that we don't want to do it globally, but it does make sense
> for the hyperv case.

Yes; it has already solved a few open issues. Please apply.

K. Y
