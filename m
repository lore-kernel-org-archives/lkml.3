Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbaGYHao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:30:44 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:14579
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750976AbaGYHam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:30:42 -0400
From: Dexuan Cui <decui@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
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
Thread-Index: AQHPmxomm/KqEa/v4Um4SutDBv4Gq5uuh6yQgAAnxgCAAcnoIA==
Date: Fri, 25 Jul 2014 07:15:11 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C98DF851@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1404875063-27424-1-git-send-email-decui@microsoft.com>
 <EE124450C0AAF944A40DD71E61F878C98D83A8@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140724035328.GB7484@kroah.com>
In-Reply-To: <20140724035328.GB7484@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.87]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(51704005)(189002)(45984002)(164054003)(377454003)(13464003)(79102001)(68736004)(55846006)(106116001)(69596002)(50986999)(47776003)(33656002)(99396002)(4396001)(21056001)(26826002)(85306003)(74502001)(23726002)(44976005)(19580405001)(74662001)(86362001)(77096002)(87936001)(46406003)(19580395003)(92566001)(110136001)(2351001)(81542001)(2656002)(95666004)(83072002)(64706001)(106466001)(16796002)(85806002)(81342001)(107046002)(76176999)(76482001)(80022001)(97736001)(54356999)(83322001)(81156004)(92726001)(86612001)(50466002)(6806004)(97756001)(31966008)(46102001)(85852003)(84676001)(77982001)(20776003);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0675;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, July 24, 2014 11:53 AM
> > So, hi Greg and all,
> > If you think the patch itself is OK, may I know if it's OK for the patch to go
> > into Greg's char-misc.git tree, as some other hyper-v patches did?
> 
> No, it needs to go through the fb tree, not mine, sorry.
> 
> greg k-h

Hi Greg,
Thank you very much for the clarification!
It's clear to me now.
Let me just wait the framebuffer maintainers' reply. :-)

Thanks,
-- Dexuan
