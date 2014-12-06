Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaLFCcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:32:17 -0500
Received: from mail-bn1on0115.outbound.protection.outlook.com ([157.56.110.115]:16334
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751051AbaLFCcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:32:16 -0500
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V3 1/1] Drivers: hv: vmbus: Implement a clockevent device
Thread-Topic: [PATCH V3 1/1] Drivers: hv: vmbus: Implement a clockevent device
Thread-Index: AQHQEOGo1jT68BHah0aL3Qb0Zjbe5ZyB155w
Date: Sat, 6 Dec 2014 02:32:06 +0000
Message-ID: <BY2PR0301MB071187FDC0113EB30B1E40EFA0660@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417825644-20978-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1417825644-20978-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;
x-forefront-prvs: 0417A3FFD2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(51704005)(13464003)(189002)(199003)(105586002)(106356001)(106116001)(2501002)(2561002)(40100003)(99286002)(107886001)(77156002)(21056001)(4396001)(46102003)(74316001)(76576001)(97736003)(107046002)(122556002)(68736005)(31966008)(101416001)(2421001)(19580395003)(54206007)(33656002)(19580405001)(76176999)(66066001)(99396003)(20776003)(1511001)(62966003)(64706001)(120916001)(50986999)(2656002)(54356999)(86362001)(54606007)(87936001)(2201001)(92566001)(86612001)(102836002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0647;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Friday, December 5, 2014 4:27 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: KY Srinivasan
> Subject: [PATCH V3 1/1] Drivers: hv: vmbus: Implement a clockevent device
> 
> Implement a clockevent device based on the timer support available on
> Hyper-V.
> In This version of the patch I have addressed Jason's review comments.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Jason Wang <jasowang@redhat.com>

Greg,

Please drop this patch, I have mailed the wrong patch. I will send the correct one shortly.

K. Y
