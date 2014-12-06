Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaLFQTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 11:19:25 -0500
Received: from mail-by2on0108.outbound.protection.outlook.com ([207.46.100.108]:60288
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751639AbaLFQTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 11:19:24 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Implement a clockevent device
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Implement a clockevent device
Thread-Index: AQHQEP8uz220NiObKUSbFrVqaEdmz5yCAxgAgAC62sA=
Date: Sat, 6 Dec 2014 16:19:21 +0000
Message-ID: <BY2PR0301MB07113876EAD7FDD4B09B09B3A0660@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417838324-26378-1-git-send-email-kys@microsoft.com>
 <20141206050734.GA6562@kroah.com>
In-Reply-To: <20141206050734.GA6562@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;
x-forefront-prvs: 0417A3FFD2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(377454003)(13464003)(51704005)(24454002)(54206007)(33656002)(19580395003)(66066001)(76176999)(19580405001)(68736005)(31966008)(101416001)(54606007)(87936001)(86612001)(2656002)(54356999)(50986999)(86362001)(102836002)(92566001)(77156002)(20776003)(99396003)(62966003)(64706001)(120916001)(110136001)(105586002)(106116001)(106356001)(99286002)(40100003)(122556002)(107046002)(97736003)(46102003)(74316001)(76576001)(21056001)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0662;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, December 5, 2014 9:08 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Implement a clockevent device
> 
> On Fri, Dec 05, 2014 at 07:58:44PM -0800, K. Y. Srinivasan wrote:
> > Implement a clockevent device based on the timer support available on
> > Hyper-V.
> > In this version of the patch I have addressed Jason's review comments.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Jason Wang <jasowang@redhat.com>
> > ---
> 
> Why did you resend the 1st version of this patch?
> 
> If you didn't send the first version, why is there no more "vX" on the Subject
> line?
> 
> confused.

Greg,

Sorry, please drop this. I will resend with the correct version number in the subject line.

Regards,

K. Y
> 
> greg k-h
