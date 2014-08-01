Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaHAKX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:23:59 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:55721
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753793AbaHAKX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:23:57 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH v3] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Topic: [PATCH v3] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Index: AQHPrAHsLR3FR7YCb0qbISFqmZOZ7pu58uTAgAA+b4CAAUM8cA==
Date: Fri, 1 Aug 2014 10:22:53 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C98FBD6A@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1404875063-27424-1-git-send-email-decui@microsoft.com>
 <53D90008.4060908@ti.com>
 <EE124450C0AAF944A40DD71E61F878C98F6F78@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <53DA46C3.9080905@ti.com>
In-Reply-To: <53DA46C3.9080905@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.92]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(13464003)(189002)(199002)(377454003)(164054003)(83072002)(74662001)(86362001)(97756001)(92726001)(92566001)(50466002)(44976005)(19580395003)(86612001)(81542001)(6806004)(20776003)(47776003)(16796002)(31966008)(74502001)(46406003)(81342001)(83322001)(55846006)(46102001)(77982001)(21056001)(107046002)(26826002)(69596002)(2656002)(84676001)(106466001)(76176999)(81156004)(64706001)(110136001)(106116001)(99396002)(97736001)(85806002)(85852003)(23726002)(19580405001)(87936001)(4396001)(95666004)(68736004)(54356999)(33656002)(50986999)(80022001)(76482001)(79102001)(93886004)(77096002)(85306004);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB247;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 029097202E
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Tomi Valkeinen [mailto:tomi.valkeinen@ti.com]
> Sent: Thursday, July 31, 2014 21:38 PM
> > I think in hvfb_on_panic() we should be able to get the
> > hvfb_info pointer by
> > hvfb_info = container_of(nb, struct hv_fb_panic_nb, nb).
> >
> > If you like that or have a better idea, please let me know so
> > I can make a new patch.
> 
> Or maybe you can add the notifier_block and the synchronous_fb to
> hvfb_par? From the notifier_block pointer you could then get hvfp_par,
> and from there hvfb_info.
>  Tomi

Hi Tomi,
Thanks a lot for the suggestion! It's better.
I'll send out a v4 patch for your review.

Thanks,
-- Dexuan

