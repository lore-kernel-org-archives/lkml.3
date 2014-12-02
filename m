Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392AbaLBWTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:19:10 -0500
Received: from mail-bn1on0136.outbound.protection.outlook.com ([157.56.110.136]:29460
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933168AbaLBWTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:19:07 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/3] Drivers: hv: hv_balloon: Make adjustments in
 computing the floor
Thread-Topic: [PATCH 1/3] Drivers: hv: hv_balloon: Make adjustments in
 computing the floor
Thread-Index: AQHQDnWwkwx1vsm2zk+Gt2U1foducZx811OAgAADHlA=
Date: Tue, 2 Dec 2014 22:03:37 +0000
Message-ID: <BY2PR0301MB0711B966D10752C4C308C27EA07A0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417559331-13691-1-git-send-email-kys@microsoft.com>
 <1417559355-13730-1-git-send-email-kys@microsoft.com>
 <20141202215127.GJ4994@mwanda>
In-Reply-To: <20141202215127.GJ4994@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-forefront-prvs: 0413C9F1ED
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(51704005)(199003)(13464003)(189002)(24454002)(19580395003)(19580405001)(21056001)(97736003)(110136001)(99396003)(86612001)(76176999)(50986999)(86362001)(20776003)(40100003)(54606007)(64706001)(122556002)(54356999)(31966008)(87936001)(2656002)(46102003)(120916001)(4396001)(54206007)(92566001)(92726001)(76576001)(106116001)(107046002)(106356001)(62966003)(33656002)(101416001)(105586002)(77156002)(99286002)(68736005)(95666004)(74316001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Tuesday, December 2, 2014 1:51 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH 1/3] Drivers: hv: hv_balloon: Make adjustments in
> computing the floor
> 
> On Tue, Dec 02, 2014 at 02:29:13PM -0800, K. Y. Srinivasan wrote:
> > Make adjustments in computing the balloon floor.
> >
> 
> The changelog should say what the user visible effects of the bug are.

Thanks Dan; I will make the log more descriptive.

K. Y
> 
> regards,
> dan carpenter

