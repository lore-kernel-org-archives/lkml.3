Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaIOSjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:39:15 -0400
Received: from mail-by2on0126.outbound.protection.outlook.com ([207.46.100.126]:2848
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753089AbaIOSjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:39:13 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH V2 0/5] Drivers: hv: vmbus: Eliminate calls to BUG_ON()
Thread-Topic: [PATCH V2 0/5] Drivers: hv: vmbus: Eliminate calls to BUG_ON()
Thread-Index: AQHPw1r3Zanm1nEhm0a/E/TjkVvBiZwCoZ8Q
Date: Mon, 15 Sep 2014 18:39:11 +0000
Message-ID: <d03e1a5aff0a4b28a447b3db3bf54f78@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1409181905-23254-1-git-send-email-kys@microsoft.com>
 <20140829072918.GA842@sucs.org>
In-Reply-To: <20140829072918.GA842@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e0:ee43::5]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03355EE97E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(377454003)(13464003)(51704005)(164054003)(199003)(189002)(76176999)(110136001)(80022001)(79102001)(19580395003)(85306004)(20776003)(107046002)(99396002)(46102001)(76482001)(64706001)(105586002)(50986999)(106116001)(77096002)(21056001)(81542001)(4396001)(15975445006)(108616004)(81342001)(85852003)(77982001)(86612001)(74502001)(97736003)(90102001)(101416001)(74662001)(19580405001)(54356999)(99286002)(86362001)(83322001)(74316001)(106356001)(87936001)(15202345003)(76576001)(33646002)(83072002)(15395725005)(2656002)(95666004)(3826002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Friday, August 29, 2014 12:29 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; Dexuan Cui
> Subject: Re: [PATCH V2 0/5] Drivers: hv: vmbus: Eliminate calls to BUG_ON()
> 
> On Wed, Aug 27, 2014 at 04:25:05PM -0700, K. Y. Srinivasan wrote:
> > Cleanup the channel management code and eliminate calls to BUG_ON().
> > Also fix an error propagation bug in vmbus_open().
> >
> > In this version of the patch-set, I have addressed comments from Dan
> > Carpenter.
> >
> > K. Y. Srinivasan (5):
> >   Drivers: hv: vmbus: Cleanup vmbus_post_msg()
> >   Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
> >   Drivers: hv: vmbus: Cleanup vmbus_close_internal()
> >   Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
> >   Drivers: hv: vmbus: Fix a bug in vmbus_open()
> 
> This patch set resolves a number of BUG_ON crashes I was hitting on Hyper-
> V while booting a kernel with verification options on. With these I can
> complete a 3.17.0-rc2 boot on an SMP setup although patches from
> "Drivers: hv: vmbus: Miscellaneous cleanup" are needed to resolve other
> non-crash issues.
> 
> Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

Greg,

Just checking if I should resend this patch-set. I have also sent a few patches after this.
Please let me know.

Thanks,

K. Y
> 
> --
> Sitsofe | http://sucs.org/~sits/
