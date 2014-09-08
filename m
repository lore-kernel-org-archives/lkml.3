Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbaIHTum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:50:42 -0400
Received: from mail-by2on0109.outbound.protection.outlook.com ([207.46.100.109]:3424
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752665AbaIHTuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:50:39 -0400
X-Greylist: delayed 1100 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 15:50:39 EDT
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Thread-Topic: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Thread-Index: AQHPxv6/GORoYjEt3E6tVTV95tJxCJvyCb0AgAWa0NA=
Date: Mon, 8 Sep 2014 19:17:00 +0000
Message-ID: <155acb7b8a3d4532aaa280e44f62447f@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1409701396-20226-1-git-send-email-kys@microsoft.com>
 <20140905054014.GA11595@infradead.org>
In-Reply-To: <20140905054014.GA11595@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e0:ee43::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03283976A6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019017)(6009001)(51704005)(377454003)(13464003)(199003)(189002)(74316001)(99396002)(19580395003)(80022001)(99286002)(86362001)(76482001)(85306004)(87936001)(83322001)(76176999)(19580405001)(85852003)(50986999)(83072002)(81342001)(54356999)(77982001)(101416001)(31966008)(74502001)(81542001)(46102001)(107046002)(86612001)(90102001)(64706001)(20776003)(76576001)(95666004)(21056001)(74662001)(105586002)(77096002)(92566001)(108616004)(2656002)(4396001)(79102001)(110136001)(106116001)(33646002)(106356001)(97736003)(26583001)(24736002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, September 4, 2014 10:40 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
> 
> Looks good to me.
> 
> Olaf, Hannes - can I get another review for this (and the older hyperv
> scanning patch set)?

Olaf, Hannes,

Ping.

K. Y
