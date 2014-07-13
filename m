Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaGMSz4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 14:55:56 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:58363
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750954AbaGMSzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 14:55:47 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 0/7] Drivers: scsi: storvsc: Bug fixes and improvements
Thread-Topic: [PATCH V3 0/7] Drivers: scsi: storvsc: Bug fixes and
 improvements
Thread-Index: AQHPneibZRiLer3ub0O4mLX3TlxqBJudxBgAgACScTA=
Date: Sun, 13 Jul 2014 18:37:40 +0000
Message-ID: <198e3f0daafa415d93fdad3e6c0c9433@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com>
 <20140713095102.GB19682@infradead.org>
In-Reply-To: <20140713095102.GB19682@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0271483E06
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(199002)(189002)(13464003)(377454003)(99396002)(50986999)(83322001)(77982001)(74316001)(19580395003)(92566001)(2656002)(106116001)(85306003)(105586002)(66066001)(46102001)(31966008)(4396001)(86612001)(74502001)(95666004)(21056001)(81542001)(20776003)(110136001)(19580405001)(33646001)(86362001)(76576001)(107046002)(85852003)(83072002)(76176999)(64706001)(101416001)(81342001)(87936001)(80022001)(76482001)(106356001)(74662001)(54356999)(79102001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Sunday, July 13, 2014 2:51 AM
> To: KY Srinivasan
> Cc: jasowang@redhat.com; apw@canonical.com; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH V3 0/7] Drivers: scsi: storvsc: Bug fixes and
> improvements
> 
> The series looks good to me, although I'll probably put the commit message
> for the timer patch into the comment for the eh_timed_out handler.

Do you want me to send the patch out with the additional comments. Would
you be checking these in.

K. Y
> 
> Can I get another set of reviews?  I've seen Olaf has put them into the SLES
> tree, so I'd expect he's done a review already?

