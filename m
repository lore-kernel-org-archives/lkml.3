Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbaGIUBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:01:35 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:50045
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753276AbaGIUBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:01:33 -0400
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
Subject: RE: [PATCH 3/8] Drivers: scsi: storvsc: Fix a bug in handling VMBUS
 protocol version
Thread-Topic: [PATCH 3/8] Drivers: scsi: storvsc: Fix a bug in handling VMBUS
 protocol version
Thread-Index: AQHPmwbaL4OFbcPZDESYgn4FKibsEZuXbTcAgAC9xnA=
Date: Wed, 9 Jul 2014 20:01:30 +0000
Message-ID: <081524cbbab044ae842c9ed3ed1cc916@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-3-git-send-email-kys@microsoft.com>
 <20140709084154.GC6012@infradead.org>
In-Reply-To: <20140709084154.GC6012@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(199002)(51704005)(13464003)(377454003)(106356001)(19580405001)(2656002)(64706001)(54356999)(74316001)(76576001)(19580395003)(81342001)(105586002)(83322001)(31966008)(99396002)(76482001)(92566001)(95666004)(50986999)(86612001)(79102001)(99286002)(80022001)(106116001)(77982001)(83072002)(46102001)(66066001)(21056001)(74502001)(101416001)(33646001)(20776003)(85852003)(81542001)(74662001)(76176999)(4396001)(107046002)(110136001)(93886003)(86362001)(85306003)(87936001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 9, 2014 1:42 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 3/8] Drivers: scsi: storvsc: Fix a bug in handling VMBUS
> protocol version
> 
> > +	if ((vmbus_proto_version == VERSION_WS2008) ||
> > +	     (vmbus_proto_version == VERSION_WIN7)) {
> 
> This has superflous braces and doesn't use proper Linux indentation.
> 
> But I think simply using a switch here might be cleaner anyway.
I will do as you have suggested.

K. Y
