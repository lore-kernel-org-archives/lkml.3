Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750818AbaIWEAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:00:37 -0400
Received: from mail-bn1on0137.outbound.protection.outlook.com ([157.56.110.137]:53728
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750709AbaIWEAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:00:35 -0400
From: Dexuan Cui <decui@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Tools: hv: vssdaemon: ignore the EBUSY on multiple
 freezing the same partition
Thread-Topic: [PATCH] Tools: hv: vssdaemon: ignore the EBUSY on multiple
 freezing the same partition
Thread-Index: AQHP1oZZBfr3eXOFxkGz209uQpWGYJwOGBxQ
Date: Tue, 23 Sep 2014 03:59:51 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C99F051A@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1411408933-11060-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1411408933-11060-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(51704005)(377454003)(189002)(199003)(164054003)(13464003)(107046002)(50986999)(76176999)(99396002)(77982003)(81342003)(74502003)(81542003)(46102003)(79102003)(74662003)(46406003)(54356999)(64706001)(97756001)(20776003)(10300001)(86612001)(92566001)(2201001)(76482002)(16796002)(92726001)(47776003)(33656002)(85852003)(86362001)(83072002)(77096002)(50466002)(31966008)(23726002)(81156004)(106466001)(2656002)(87936001)(85806002)(19580405001)(6806004)(19580395003)(120916001)(80022003)(83322001)(44976005)(106116001)(2501002)(90102001)(97736003)(85306004)(69596002)(21056001)(95666004)(4396001)(84676001)(55846006)(68736004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1214;H:mail.microsoft.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1214;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0343AC1D30
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Dexuan Cui
> Sent: Tuesday, September 23, 2014 2:02 AM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: KY Srinivasan; Haiyang Zhang
> Subject: [PATCH] Tools: hv: vssdaemon: ignore the EBUSY on multiple
> freezing the same partition
> 
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_vss_daemon.c | 21 +++++++++++++++++++++

Please use the v2 patch I sent out just now.
I added a "errno = 0;' before the ioctl() to fix some false warnings.

Thanks,
-- Dexuan
