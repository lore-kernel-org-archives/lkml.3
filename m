Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbaLJTQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:16:35 -0500
Received: from mail-by2on0143.outbound.protection.outlook.com ([207.46.100.143]:39088
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932731AbaLJTQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:16:34 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mcb30@ipxe.org" <mcb30@ipxe.org>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in
 vmbus_establish_gpadl()
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in
 vmbus_establish_gpadl()
Thread-Index: AQHQFKer7gqbu2R8oUqbpmrdZ8/qUJyJLcyAgAAEZzA=
Date: Wed, 10 Dec 2014 19:16:31 +0000
Message-ID: <BY2PR0301MB07111A1C71A2C0FF1BDA076BA0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418240563-6590-1-git-send-email-kys@microsoft.com>
 <20141210190025.GA2015@kroah.com>
In-Reply-To: <20141210190025.GA2015@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-forefront-prvs: 0421BF7135
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(6009001)(199003)(189002)(13464003)(51704005)(377454003)(24454002)(62966003)(31966008)(77156002)(74316001)(50986999)(110136001)(2656002)(102836002)(86362001)(101416001)(87936001)(76176999)(107046002)(54356999)(21056001)(76576001)(40100003)(4396001)(97736003)(99396003)(46102003)(122556002)(120916001)(19580395003)(19580405001)(106116001)(106356001)(92566001)(86612001)(68736005)(105586002)(64706001)(99286002)(33656002)(20776003)(3826002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, December 10, 2014 11:00 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com;
> mcb30@ipxe.org
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in
> vmbus_establish_gpadl()
> 
> On Wed, Dec 10, 2014 at 11:42:43AM -0800, K. Y. Srinivasan wrote:
> > Fix a bug in vmbus_establish_gpadl(). I would like to thank Michael
> > Brown <mcb30@ipxe.org> for seeing this bug.
> 
> Then use the "Reported-by:" tag with his name in this patch please.

Will do. I will resend it.
> 
> thanks,
> 
> greg k-h
