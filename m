Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaIWEUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:20:51 -0400
Received: from mail-by2on0121.outbound.protection.outlook.com ([207.46.100.121]:40544
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753041AbaIWEUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:20:49 -0400
X-Greylist: delayed 853 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 00:20:49 EDT
From: Dexuan Cui <decui@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH v2] Tools: hv: vssdaemon: ignore the EBUSY on multiple
 freezing the same partition
Thread-Topic: [PATCH v2] Tools: hv: vssdaemon: ignore the EBUSY on multiple
 freezing the same partition
Thread-Index: AQHP1uJJ6PXVH5O6DkGFF29LN6gjYJwOGTgA
Date: Tue, 23 Sep 2014 04:05:58 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C99F056A@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1411448455-12768-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1411448455-12768-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(13464003)(51704005)(189002)(164054003)(377454003)(199003)(77096002)(92566001)(106116001)(95666004)(46406003)(99396002)(2501002)(76482002)(76176999)(107046002)(50986999)(120916001)(106466001)(69596002)(2201001)(16796002)(97736003)(47776003)(81156004)(92726001)(31966008)(64706001)(86612001)(85852003)(20776003)(21056001)(83072002)(97756001)(23726002)(86362001)(90102001)(19580395003)(33656002)(2656002)(68736004)(77982003)(46102003)(85806002)(55846006)(85306004)(50466002)(87936001)(44976005)(81542003)(6806004)(74662003)(79102003)(81342003)(83322001)(54356999)(80022003)(19580405001)(4396001)(74502003)(10300001)(84676001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1202;H:mail.microsoft.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1202;
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
> Sent: Tuesday, September 23, 2014 13:01 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: KY Srinivasan; Haiyang Zhang
> Subject: [PATCH v2] Tools: hv: vssdaemon: ignore the EBUSY on multiple
> freezing the same partition
> 
> v2: I added "errno = 0;" in the ioctl()
typo --   "in the ioctl(")  should be "before the ioctl()".

Thanks,
-- Dexuan
